#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Function to display help
show_help() {
    echo "Kubernetes Setup CLI"
    echo ""
    echo "Usage: $0 [options] [components]"
    echo ""
    echo "Options:"
    echo "  --help, -h              Show this help message"
    echo "  --list, -l              List available components and their status"
    echo "  --enable-all            Enable all components"
    echo "  --disable-all           Disable all components"
    echo "  --reset                 Reset to default configuration"
    echo ""
    echo "Components:"
    echo "  metallb                 Enable MetalLB"
    echo "  no-metallb              Disable MetalLB"
    echo "  ingress-nginx           Enable Ingress NGINX"
    echo "  no-ingress-nginx        Disable Ingress NGINX"
    echo "  cert-manager            Enable Cert Manager"
    echo "  no-cert-manager         Disable Cert Manager"
    echo "  prometheus              Enable Prometheus Stack"
    echo "  no-prometheus           Disable Prometheus Stack"
    echo "  metrics-server          Enable Metrics Server"
    echo "  no-metrics-server       Disable Metrics Server"
    echo ""
    echo "Examples:"
    echo "  $0 --list               List component status"
    echo "  $0 metallb              Enable MetalLB"
    echo "  $0 --disable-all prometheus  Disable all components except Prometheus"
    echo ""
}

# Function to list components and their status
list_components() {
    echo "Current Component Configuration:"
    echo ""
    echo "Core Components:"
    echo "  MetalLB:       ${ENABLE_METALLB}"
    echo "  Ingress NGINX: ${ENABLE_INGRESS_NGINX}"
    echo "  Cert Manager:  ${ENABLE_CERT_MANAGER}"
    echo ""
    echo "Optional Components:"
    echo "  Prometheus:    ${ENABLE_PROMETHEUS}"
    echo "  Metrics Server: ${ENABLE_METRICS_SERVER}"
    echo ""
    echo "Configuration file: $ENV_FILE"
}

# Function to update configuration
update_env_value() {
    local key=$1
    local value=$2

    # Create .env file if it doesn't exist
    if [ ! -f "$ENV_FILE" ]; then
        mkdir -p "$(dirname "$ENV_FILE")"
        cp "$ENV_TEMPLATE" "$ENV_FILE"
    fi

    # Check if key exists in file
    if grep -q "^${key}=" "$ENV_FILE"; then
        # Update existing key
        sed -i '' "s|^${key}=.*|${key}=${value}|" "$ENV_FILE"
    else
        # Add new key
        echo "${key}=${value}" >>"$ENV_FILE"
    fi

    # Update current environment
    export "$key=$value"

    echo "Updated ${key} to ${value}"
}

# Function to enable all components
enable_all() {
    update_env_value "ENABLE_METALLB" "true"
    update_env_value "ENABLE_INGRESS_NGINX" "true"
    update_env_value "ENABLE_CERT_MANAGER" "true"
    update_env_value "ENABLE_PROMETHEUS" "true"
    update_env_value "ENABLE_METRICS_SERVER" "true"
    echo "All components enabled"
}

# Function to disable all components
disable_all() {
    update_env_value "ENABLE_METALLB" "false"
    update_env_value "ENABLE_INGRESS_NGINX" "false"
    update_env_value "ENABLE_CERT_MANAGER" "false"
    update_env_value "ENABLE_PROMETHEUS" "false"
    update_env_value "ENABLE_METRICS_SERVER" "false"
    echo "All components disabled"
}

# Function to reset to default configuration
reset_config() {
    if [ -f "$ENV_FILE" ]; then
        rm "$ENV_FILE"
        cp "$ENV_TEMPLATE" "$ENV_FILE"
        echo "Configuration reset to defaults"
        # Reload environment variables
        load_env_file "$ENV_FILE"
    else
        echo "No custom configuration found"
    fi
}

# Process command line arguments
if [ $# -eq 0 ]; then
    show_help
    exit 0
fi

while [ $# -gt 0 ]; do
    case "$1" in
    --help | -h)
        show_help
        exit 0
        ;;
    --list | -l)
        list_components
        exit 0
        ;;
    --enable-all)
        enable_all
        shift
        ;;
    --disable-all)
        disable_all
        shift
        ;;
    --reset)
        reset_config
        shift
        ;;
    metallb)
        update_env_value "ENABLE_METALLB" "true"
        shift
        ;;
    no-metallb)
        update_env_value "ENABLE_METALLB" "false"
        shift
        ;;
    ingress-nginx)
        update_env_value "ENABLE_INGRESS_NGINX" "true"
        shift
        ;;
    no-ingress-nginx)
        update_env_value "ENABLE_INGRESS_NGINX" "false"
        shift
        ;;
    cert-manager)
        update_env_value "ENABLE_CERT_MANAGER" "true"
        shift
        ;;
    no-cert-manager)
        update_env_value "ENABLE_CERT_MANAGER" "false"
        shift
        ;;
    prometheus)
        update_env_value "ENABLE_PROMETHEUS" "true"
        shift
        ;;
    no-prometheus)
        update_env_value "ENABLE_PROMETHEUS" "false"
        shift
        ;;
    metrics-server)
        update_env_value "ENABLE_METRICS_SERVER" "true"
        shift
        ;;
    no-metrics-server)
        update_env_value "ENABLE_METRICS_SERVER" "false"
        shift
        ;;
    *)
        echo "Unknown option: $1"
        show_help
        exit 1
        ;;
    esac
done
