#!/bin/bash

set -e

# Source common functions if not already sourced
if [ -z "$KUBERNETES_VERSION" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/../common.sh"
fi

install_prometheus() {
    print_section_header "Install prometheus stack"

    if helm repo list | grep --quiet prometheus-community; then
        echo "prometheus-community repo already added"
    else
        helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
        helm repo update
    fi

    if helm list --namespace monitoring | grep --quiet prometheus; then
        echo "prometheus already installed"
    else
        sed 's/.example/.'"$LOCAL_DOMAIN"'/g' "$DOTFILES_DIR/etc/kind/kube-prometheus-stack.yaml" |
            helm install \
                --wait \
                --timeout 5m \
                --namespace monitoring \
                --create-namespace \
                prometheus prometheus-community/kube-prometheus-stack \
                --values -
        kubectl wait --namespace monitoring \
            --for=condition=ready pod \
            --selector=app=kube-prometheus-stack-operator \
            --timeout=90s

        update_etc_hosts "prometheus.$LOCAL_DOMAIN"
        update_etc_hosts "grafana.$LOCAL_DOMAIN"
        update_etc_hosts "alertmanager.$LOCAL_DOMAIN"
    fi
}

# Install prometheus
install_prometheus
