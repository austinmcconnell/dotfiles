#!/bin/bash

if is-executable kind; then
    echo "**************************************************"
    echo "Configuring kubernetes"
    echo "**************************************************"
else
    if is-macos; then
        echo "**************************************************"
        echo "Installing Kubernetes"
        echo "**************************************************"
        brew install kind kubectl kubectx helm
    elif is-debian; then
        echo "**************************************************"
        echo "Installing Kubernetes"
        echo "**************************************************"
        sudo apt install -y kind kubectl
    else
        echo "**************************************************"
        echo "Skipping Kubernetes installation: Unidentified OS"
        echo "**************************************************"
        return
    fi
fi

KUBERNETES_VERSION=v1.29.2

# Install Docker Mac Net Connect
# Allows connecting directly to Docker-for-Mac container via their IP address
# https://github.com/chipmk/docker-mac-net-connect
if brew services list | grep -q docker-mac-net-connect; then
    brew services info docker-mac-net-connect
else
    brew install chipmk/tap/docker-mac-net-connect
    sudo brew services start chipmk/tap/docker-mac-net-connect
fi

existing_clusters=$(kind get clusters --quiet)

if [[ $existing_clusters =~ "kind" ]]; then
    kubectl cluster-info --context kind-kind
else
    kind create cluster --wait 3m --config "$DOTFILES_DIR/etc/kind/cluster-config.yaml" --image "kindest/node:$KUBERNETES_VERSION"
    kubectl cluster-info --context kind-kind

    # Add any mounted certs
    nodes=$(kind get nodes)
    for node in $nodes; do
        echo "Updating certs on node: $node"
        docker exec "$node" update-ca-certificates
        docker exec "$node" systemctl restart containerd
    done

    # Enable LoadBalancer (FIXME: This isn't quite working yet... Not sure why.)
    # It works when I run `sudo cloud-provider-kind` locally. Compare output? Mac/Docker networking issue?
    kubectl label node kind-control-plane node.kubernetes.io/exclude-from-external-load-balancers-

    KUBERNETES_SIGS_DIR="$HOME/projects/kubernetes-sigs"
    CLOUD_PROVIDER_KIND_DIR="$KUBERNETES_SIGS_DIR/cloud-provider-kind"
    mkdir -p "$KUBERNETES_SIGS_DIR"

    if [ -d "$CLOUD_PROVIDER_KIND_DIR/.git" ]; then
        git --work-tree="$CLOUD_PROVIDER_KIND_DIR" --git-dir="$CLOUD_PROVIDER_KIND_DIR/.git" pull origin main
    else
        git clone https://github.com/kubernetes-sigs/cloud-provider-kind "$CLOUD_PROVIDER_KIND_DIR"
    fi

    pushd "$CLOUD_PROVIDER_KIND_DIR" || exit
    docker build . -t cloud-provider-kind
    # FIXME: https://github.com/kubernetes-sigs/cloud-provider-kind/issues/115
    NET_MODE=kind docker compose up -d
    popd || exit

    # Set up ingress-nginx
    helm install \
        --wait \
        --timeout 5m \
        --namespace ingress-nginx \
        --create-namespace \
        --repo https://kubernetes.github.io/ingress-nginx \
        ingress-nginx ingress-nginx
    kubectl wait --namespace ingress-nginx \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=90s

    # Set up prometheus
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    helm install --wait \
        --timeout 5m \
        --namespace monitoring \
        --create-namespace \
        --values "$DOTFILES_DIR/etc/kind/kube-prometheus-stack.yaml" \
        kind-prometheus prometheus-community/kube-prometheus-stack
    kubectl wait --namespace monitoring \
        --for=condition=ready pod \
        --selector=app=kube-prometheus-stack-operator \
        --timeout=90s
fi
