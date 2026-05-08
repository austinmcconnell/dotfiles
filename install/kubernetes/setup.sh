#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source common functions
source "$SCRIPT_DIR/common.sh"

if [[ -z "${LOCAL_DOMAIN}" ]]; then
    log_error "LOCAL_DOMAIN is not set. See the env template in etc/kubernetes/ for configuration."
    exit 1
fi

# Install Kubernetes tools if not already installed
if ! is-executable k3d; then
    if is-macos; then
        print_section_header "Installing Kubernetes"
        brew install k3d kubectl kubectx helm mkcert helmfile
    elif is-debian; then
        print_section_header "Installing Kubernetes"
        sudo apt install -y k3d kubectl
    else
        print_section_header "Skipping Kubernetes installation: Unidentified OS"
        exit 1
    fi
fi

# Create k3d cluster
if k3d cluster list --no-headers 2>/dev/null | grep --quiet "^dev "; then
    print_section_header "Cluster already exists"
    kubectl get nodes --context k3d-dev
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

# Wait for ingress-nginx admission webhook if it exists — helmfile will fail
# validating ingress resources if the webhook isn't ready
kubectl wait --for=condition=ready pod -l app.kubernetes.io/component=controller \
    -n ingress-nginx --timeout=60s --context k3d-dev 2>/dev/null >/dev/null || true

helmfile --file "$CONFIG_DIR/helmfile.yaml" sync --concurrency 1 2>&1 |
    grep --line-buffered -E "^(Upgrading|Release|Building)" |
    sed 's/Upgrading release=\([^,]*\),.*/Syncing \1.../; s/Release "\([^"]*\)".*/\1 ✓/'

# Apply non-Helm resources
if [ "${ENABLE_KEDA_DEMO:-true}" = "true" ]; then
    print_section_header "Applying KEDA demo manifests"
    kubectl apply -f "$CONFIG_DIR/manifests/keda-demo-worker.yaml"
    kubectl apply -f "$CONFIG_DIR/manifests/keda-demo-scaledobject.yaml"
fi

if [ "${ENABLE_LIMIT_RANGE}" = "true" ]; then
    apply_limit_ranges
fi

if [ "${ENABLE_RESOURCE_QUOTA}" = "true" ]; then
    apply_resource_quotas
fi

# Post-install: hosts entries and tests
add_hosts_entries
run_tests

print_section_header "Kubernetes setup complete"
echo ""
echo "  Dashboard URLs (requires running cluster):"
echo "    Grafana:      https://grafana.${LOCAL_DOMAIN}"
echo "    Prometheus:   https://prometheus.${LOCAL_DOMAIN}"
echo "    Alertmanager: https://alertmanager.${LOCAL_DOMAIN}"
echo "    Podinfo:      https://podinfo.${LOCAL_DOMAIN}"
echo ""
echo "  Grafana admin password:"
echo "    kubectl -n monitoring get secret prometheus-grafana -o jsonpath=\"{.data.admin-password}\" | base64 -d"
echo ""
echo "  Start cluster:  k3d cluster start dev"
