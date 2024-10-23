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
        brew install kind kubectl kubectx
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
fi
