#!/bin/bash

set -e

# Source common functions if not already sourced
if [ -z "$KUBERNETES_VERSION" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/../common.sh"
fi

install_cert_manager() {
    print_section_header "Installing cert-manager"

    if helm repo list | grep --quiet jetstack; then
        echo "jetstack repo already added"
    else
        helm repo add jetstack https://charts.jetstack.io
        helm repo update
    fi

    if helm list --namespace cert-manager | grep --quiet cert-manager; then
        echo "cert-manager already installed"
        # helm diff support for --reset-then-reuse-values is merged in but not released yet
        # https://github.com/databus23/helm-diff/pull/634
        # if [[ -n $(helm diff upgrade --reset-then-reuse-values --namespace cert-manager cert-manager jetstack/cert-manager) ]]; then
        #     echo "Upgrading cert-manager"
        #     helm upgrade --reset-then-reuse-values --namespace cert-manager cert-manager jetstack/cert-manager
        # else
        #     echo "No upgrade needed"
        # fi
    else
        helm install \
            --namespace cert-manager \
            --create-namespace \
            --version v1.16.1 \
            --values "$DOTFILES_DIR/etc/kind/cert-manager.yaml" \
            cert-manager jetstack/cert-manager
        kubectl rollout --namespace cert-manager status deployment cert-manager

        # Generate and install local CA
        mkcert -install

        # Add CA's certificate and key to kubernetes
        kubectl create secret tls mkcert-ca-key-pair \
            --key "$(mkcert -CAROOT)"/rootCA-key.pem \
            --cert "$(mkcert -CAROOT)"/rootCA.pem -n cert-manager

        # Tell cert-manager to use this to issue certificates
        kubectl apply -f "$DOTFILES_DIR/etc/kind/cert-manager-cluster-issuer.yaml"
    fi

    print_section_header "Testing cert-manager"
    sh "$DOTFILES_DIR/etc/kind/test/test-cert-manager.sh"
}

# Install cert-manager
install_cert_manager
