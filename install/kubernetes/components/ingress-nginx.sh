#!/bin/bash

set -e

# Source common functions if not already sourced
if [ -z "$KUBERNETES_VERSION" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/../common.sh"
fi

install_ingress_nginx() {
    print_section_header "Installing ingress-nginx"

    if helm repo list | grep --quiet ingress-nginx; then
        echo "ingress-nginx repo already added"
    else
        helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
        helm repo update
    fi

    if helm list --namespace ingress-nginx | grep --quiet ingress-nginx; then
        echo "ingress-nginx already installed"
        if [[ -n $(helm diff upgrade --reuse-values --namespace ingress-nginx ingress-nginx ingress-nginx/ingress-nginx) ]]; then
            echo "Upgrading ingress-nginx"
            helm upgrade --reuse-values --namespace ingress-nginx ingress-nginx ingress-nginx/ingress-nginx
        else
            echo "No upgrade needed"
        fi
    else
        helm install \
            --wait \
            --timeout 5m \
            --namespace ingress-nginx \
            --create-namespace \
            ingress-nginx ingress-nginx/ingress-nginx
        kubectl wait --namespace ingress-nginx \
            --for=condition=ready pod \
            --selector=app.kubernetes-io/component=controller \
            --timeout=90s

        update_etc_hosts "$LOCAL_DOMAIN"
    fi

    print_section_header "Testing ingress-nginx"
    sh "$DOTFILES_DIR/etc/kind/test/test-ingress-nginx-port-forward.sh"
    sh "$DOTFILES_DIR/etc/kind/test/test-ingress-nginx-hosts-entry.sh"
}

# Install ingress-nginx
install_ingress_nginx
