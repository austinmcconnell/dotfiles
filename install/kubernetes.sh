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

    # Update certs
    docker exec kind-control-plane update-ca-certificates
    docker exec kind-worker update-ca-certificates
    docker exec kind-worker2 update-ca-certificates

    # Restart containerd
    docker exec kind-control-plane systemctl restart containerd
    docker exec kind-worker systemctl restart containerd
    docker exec kind-worker2 systemctl restart containerd

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
        --timeout 15m \
        --namespace monitoring \
        --create-namespace \
        --set prometheus.service.nodePort=30000 \
        --set prometheus.service.type=NodePort \
        --set grafana.service.nodePort=31000 \
        --set grafana.service.type=NodePort \
        --set alertmanager.service.nodePort=32000 \
        --set alertmanager.service.type=NodePort \
        --set prometheus-node-exporter.service.nodePort=32001 \
        --set prometheus-node-exporter.service.type=NodePort \
        kind-prometheus prometheus-community/kube-prometheus-stack
fi
