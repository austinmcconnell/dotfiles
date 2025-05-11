#!/bin/bash

set -e

# Source common functions if not already sourced
if [ -z "$KUBERNETES_VERSION" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/../common.sh"
fi

install_resource_quota() {
    print_section_header "Installing ResourceQuota for namespaces"

    # Get all non-system namespaces
    namespaces=$(kubectl get namespaces --no-headers | grep -v "kube-" | awk '{print $1}')

    # Apply ResourceQuota to each namespace
    for namespace in $namespaces; do
        echo "Checking namespace: $namespace"

        # Check if ResourceQuota already exists in this namespace
        if kubectl get resourcequota -n "$namespace" 2>/dev/null | grep -q default-resource-quota; then
            echo "ResourceQuota already exists in namespace: $namespace"
        else
            echo "Creating ResourceQuota in namespace: $namespace"
            # Create a copy of the ResourceQuota for this namespace
            kubectl -n "$namespace" apply -f "$DOTFILES_DIR/etc/kind/resource-quota.yaml"
        fi
    done

    echo "ResourceQuotas have been applied to all non-system namespaces"

    # Display the ResourceQuotas
    kubectl get resourcequota --all-namespaces
}

# Install ResourceQuota
install_resource_quota
