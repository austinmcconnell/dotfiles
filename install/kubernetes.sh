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
