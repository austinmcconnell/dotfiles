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

# Install docker-mac-net-connect for macOS (required for proper network connectivity)
if is-macos; then
    source "$SCRIPT_DIR/docker-mac-net-connect.sh"
fi

# Create Kind cluster
source "$SCRIPT_DIR/kind-create.sh"

# Install components based on configuration
if [ "$ENABLE_METALLB" = "true" ]; then
    source "$SCRIPT_DIR/components/metallb.sh"
fi

if [ "$ENABLE_INGRESS_NGINX" = "true" ]; then
    source "$SCRIPT_DIR/components/ingress-nginx.sh"
fi

if [ "$ENABLE_CERT_MANAGER" = "true" ]; then
    source "$SCRIPT_DIR/components/cert-manager.sh"
fi

if [ "$ENABLE_PROMETHEUS" = "true" ]; then
    source "$SCRIPT_DIR/components/prometheus.sh"
fi

if [ "$ENABLE_METRICS_SERVER" = "true" ]; then
    source "$SCRIPT_DIR/components/metrics-server.sh"
fi

echo "**************************************************"
echo "Kubernetes setup complete"
echo "**************************************************"
echo ""
echo "To manage component configuration, use:"
echo "k8s-config --list         # List enabled components"
echo "k8s-config --help         # Show all options"
