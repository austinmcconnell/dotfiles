#!/bin/bash

set -e

# Source common functions if not already sourced
if [ -z "$KUBERNETES_VERSION" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/../common.sh"
fi

install_metrics_server() {
    print_section_header "Installing metrics-server"

    if helm repo list | grep --quiet metrics-server; then
        echo "metrics-server repo already added"
    else
        helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
        helm repo update
    fi

    # Check if cert-manager is enabled and installed
    if [ "$ENABLE_CERT_MANAGER" = "true" ]; then
        if helm list --namespace cert-manager | grep --quiet cert-manager; then
            echo "cert-manager installation found"
        else
            echo "cert-manager is enabled but not installed. Installing cert-manager first..."
            source "$SCRIPT_DIR/cert-manager.sh"
        fi
    else
        echo "WARNING: cert-manager is disabled. metrics-server may not function correctly."
    fi

    if helm list --namespace metrics-server | grep --quiet metrics-server; then
        echo "metrics-server already installed"
        if [[ -n $(helm diff upgrade --reuse-values --namespace metrics-server metrics-server metrics-server/metrics-server) ]]; then
            echo "Upgrading metrics-server"
            helm upgrade --reuse-values --namespace metrics-server metrics-server metrics-server/metrics-server
        else
            echo "No upgrade needed"
        fi
    else
        helm install \
            --wait \
            --timeout 5m \
            --namespace metrics-server \
            --create-namespace \
            --values "$DOTFILES_DIR/etc/kind/metrics-server.yaml" \
            metrics-server metrics-server/metrics-server
        kubectl wait --namespace metrics-server \
            --for=condition=ready pod \
            --selector=app.kubernetes.io/name=metrics-server \
            --timeout=90s

    fi

    print_section_header "Testing metrics-server"
    sh "$DOTFILES_DIR/etc/kind/test/test-metrics-server.sh"
    sh "$DOTFILES_DIR/etc/kind/test/test-horizontal-pod-autoscaler.sh"
}

# Install metrics-server
install_metrics_server
