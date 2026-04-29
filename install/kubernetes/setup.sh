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
        brew install kind kubectl kubectx helm mkcert helmsman
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

# Deploy Helm charts via helmsman
# Phase 1: Install metallb first (needs post-install IP pool config before other charts)
print_section_header "Deploying metallb via helmsman"
helmsman --apply \
    -f "$CONFIG_DIR/cluster-infrastructure.toml" \
    --target metallb

configure_metallb

# Phase 2: Install remaining charts with env var substitution for $LOCAL_DOMAIN
print_section_header "Deploying remaining charts via helmsman"
LOCAL_DOMAIN="${LOCAL_DOMAIN}" helmsman --apply \
    --subst-env-values \
    -f "$CONFIG_DIR/cluster-infrastructure.toml"

configure_cert_manager

# Apply non-Helm resources
if [ "${ENABLE_LIMIT_RANGE}" = "true" ]; then
    source "$SCRIPT_DIR/components/limit-range.sh"
fi

if [ "${ENABLE_RESOURCE_QUOTA}" = "true" ]; then
    source "$SCRIPT_DIR/components/resource-quota.sh"
fi

# Post-install: hosts entries and tests
add_hosts_entries
run_tests

# Check for available chart updates
helmsman --check-for-chart-updates

echo "**************************************************"
echo "Kubernetes setup complete"
echo "**************************************************"
