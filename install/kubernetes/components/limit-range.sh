#!/bin/bash

set -e

# Source common functions if not already sourced
if [ -z "$KUBERNETES_VERSION" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/../common.sh"
fi

install_limit_range() {
    print_section_header "Installing LimitRange for namespaces"

    # Get all non-system namespaces
    namespaces=$(kubectl get namespaces --no-headers | grep -v "kube-" | awk '{print $1}')

    # Apply LimitRange to each namespace
    for namespace in $namespaces; do
        echo "Checking namespace: $namespace"

        # Check if LimitRange already exists in this namespace
        if kubectl get limitrange -n "$namespace" 2>/dev/null | grep -q default-limit-range; then
            echo "LimitRange already exists in namespace: $namespace"
        else
            echo "Creating LimitRange in namespace: $namespace"
            # Create a copy of the LimitRange for this namespace
            kubectl -n "$namespace" apply -f "$DOTFILES_DIR/etc/kind/limit-range.yaml"
        fi
    done

    echo "LimitRanges have been applied to all non-system namespaces"

    # Display the LimitRanges
    kubectl get limitrange --all-namespaces
}

# Install LimitRange
install_limit_range
