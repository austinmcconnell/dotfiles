#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common functions
source "$SCRIPT_DIR/common.sh"

if [[ -z "${LOCAL_DOMAIN}" ]]; then
    echo "ERROR: LOCAL_DOMAIN is not set. Check the env template in etc/kubernetes/"
    exit 1
fi

# Install Kubernetes tools if not already installed
if is-executable k3d; then
    echo "**************************************************"
    echo "Configuring kubernetes"
    echo "**************************************************"
else
    if is-macos; then
        echo "**************************************************"
        echo "Installing Kubernetes"
        echo "**************************************************"
        brew install k3d kubectl kubectx helm mkcert helmfile
    elif is-debian; then
        echo "**************************************************"
        echo "Installing Kubernetes"
        echo "**************************************************"
        sudo apt install -y k3d kubectl
    else
        echo "**************************************************"
        echo "Skipping Kubernetes installation: Unidentified OS"
        echo "**************************************************"
        exit 1
    fi
fi

# Create k3d cluster
if k3d cluster list --no-headers 2>/dev/null | grep --quiet "^dev "; then
    print_section_header "Cluster already exists"
    kubectl cluster-info --context k3d-dev
else
    print_section_header "Creating k3d cluster"
    cert_args=()
    if [ -n "${CORP_CERT_PATH:-}" ] && [ -f "${CORP_CERT_PATH}" ]; then
        cert_args=(--volume "${CORP_CERT_PATH}:/etc/ssl/certs/corporate.crt@all")
    fi

    k3d cluster create --config "$CONFIG_DIR/k3d-config.yaml" ${cert_args[@]+"${cert_args[@]}"}
    echo "Waiting for nodes to be ready..."
    kubectl wait --for=condition=ready node --all --timeout=90s
    kubectl cluster-info --context k3d-dev
fi

# Ensure helm-diff plugin is installed (required by helmfile)
if ! helm plugin list | grep --quiet "^diff"; then
    helm plugin install https://github.com/databus23/helm-diff --verify=false
fi

# Deploy Helm charts via helmfile
# Dependency ordering via needs: ensures correct install sequence
# postsync hooks handle post-install configuration (e.g. cert-manager CA secret)
print_section_header "Deploying charts via helmfile"
helmfile --file "$CONFIG_DIR/helmfile.yaml" sync

# Apply non-Helm resources
if [ "${ENABLE_LIMIT_RANGE}" = "true" ]; then
    apply_limit_ranges
fi

if [ "${ENABLE_RESOURCE_QUOTA}" = "true" ]; then
    apply_resource_quotas
fi

# Post-install: hosts entries and tests
add_hosts_entries
run_tests

echo "**************************************************"
echo "Kubernetes setup complete"
echo "**************************************************"
