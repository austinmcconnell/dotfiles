#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common functions
source "$SCRIPT_DIR/common.sh"

# Install Kubernetes tools if not already installed
if is-executable kind; then
    echo "**************************************************"
    echo "Configuring kubernetes"
    echo "**************************************************"
else
    if is-macos; then
        echo "**************************************************"
        echo "Installing Kubernetes"
        echo "**************************************************"
        brew install kind kubectl kubectx helm mkcert
    elif is-debian; then
        echo "**************************************************"
        echo "Installing Kubernetes"
        echo "**************************************************"
        sudo apt install -y kind kubectl
    else
        echo "**************************************************"
        echo "Skipping Kubernetes installation: Unidentified OS"
        echo "**************************************************"
        exit 1
    fi
fi

# Install Helm plugins
source "$SCRIPT_DIR/components/helm-plugins.sh"

# Create Kind cluster
source "$SCRIPT_DIR/kind-create.sh"

# Install components
source "$SCRIPT_DIR/components/metallb.sh"
source "$SCRIPT_DIR/components/ingress-nginx.sh"
source "$SCRIPT_DIR/components/cert-manager.sh"
source "$SCRIPT_DIR/components/prometheus.sh"
source "$SCRIPT_DIR/components/metrics-server.sh"

echo "**************************************************"
echo "Kubernetes setup complete"
echo "**************************************************"
