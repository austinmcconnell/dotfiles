#!/bin/bash

# Common variables
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
CONFIG_DIR="$DOTFILES_DIR/etc/kubernetes"
ENV_FILE="$CONFIG_DIR/.env"
ENV_TEMPLATE="$CONFIG_DIR/.env.template"

# Function to load environment variables from .env file
load_env_file() {
    local env_file=$1
    if [ -f "$env_file" ]; then
        while IFS= read -r line || [ -n "$line" ]; do
            # Skip comments and empty lines
            if [[ $line =~ ^[[:space:]]*# ]] || [[ -z $line ]]; then
                continue
            fi

            # Extract variable and value
            if [[ $line =~ ^([^=]+)=(.*)$ ]]; then
                local key="${BASH_REMATCH[1]}"
                local value="${BASH_REMATCH[2]}"

                # Remove quotes if present
                value="${value%\"}"
                value="${value#\"}"
                value="${value%\'}"
                value="${value#\'}"

                # Export the variable
                export "$key=$value"
            fi
        done <"$env_file"
    fi
}

# Create .env file from template if it doesn't exist
if [ ! -f "$ENV_FILE" ] && [ -f "$ENV_TEMPLATE" ]; then
    mkdir -p "$CONFIG_DIR"
    cp "$ENV_TEMPLATE" "$ENV_FILE"
fi

# Load environment variables
load_env_file "$ENV_FILE"

# Common functions
print_section_header() {
    echo "***********************************"
    echo "$1"
    echo "***********************************"
}

update_etc_hosts() {
    local host_name=$1
    local ip_address="127.0.0.1"

    if grep --quiet --fixed-strings "$host_name" /etc/hosts; then
        echo "Hosts entry already exists for $host_name"
    else
        local host_entry="${ip_address} ${host_name}"
        local filepath
        filepath=$(readlink -f -- "$0")
        echo -e "\n# Added by $filepath" | sudo tee -a /etc/hosts >/dev/null
        echo "$host_entry" | sudo tee -a /etc/hosts >/dev/null
        echo "# End of section" | sudo tee -a /etc/hosts >/dev/null
    fi
}

configure_cert_manager() {
    # Create mkcert CA secret and ClusterIssuer after helmfile installs cert-manager
    print_section_header "Configuring cert-manager"

    if kubectl get secrets --namespace cert-manager 2>/dev/null | grep --quiet mkcert-ca-key-pair; then
        echo "mkcert-ca-key-pair already exists"
    else
        mkcert -install

        kubectl create secret tls mkcert-ca-key-pair \
            --key "$(mkcert -CAROOT)/rootCA-key.pem" \
            --cert "$(mkcert -CAROOT)/rootCA.pem" \
            --namespace cert-manager

        kubectl apply -f "$CONFIG_DIR/manifests/cert-manager-cluster-issuer.yaml"
    fi
}

add_hosts_entries() {
    print_section_header "Adding /etc/hosts entries"
    local hosts=(
        "${LOCAL_DOMAIN}"
        "prometheus.${LOCAL_DOMAIN}"
        "grafana.${LOCAL_DOMAIN}"
        "alertmanager.${LOCAL_DOMAIN}"
    )
    local needs_sudo=false
    for host in "${hosts[@]}"; do
        if ! grep --quiet --fixed-strings "$host" /etc/hosts; then
            needs_sudo=true
            break
        fi
    done
    if [ "$needs_sudo" = true ]; then
        echo "Adding hosts entries. Please enter your password, if requested."
    fi
    for host in "${hosts[@]}"; do
        update_etc_hosts "$host"
    done
}

apply_limit_ranges() {
    print_section_header "Applying LimitRange to namespaces"
    local namespaces
    namespaces=$(kubectl get namespaces --no-headers | grep -v "kube-" | awk '{print $1}')
    for ns in $namespaces; do
        kubectl -n "$ns" apply -f "$CONFIG_DIR/limit-range.yaml"
    done
    kubectl get limitrange --all-namespaces
}

apply_resource_quotas() {
    print_section_header "Applying ResourceQuota to namespaces"
    local namespaces
    namespaces=$(kubectl get namespaces --no-headers | grep -v "kube-\|monitoring" | awk '{print $1}')
    for ns in $namespaces; do
        kubectl -n "$ns" apply -f "$CONFIG_DIR/resource-quota.yaml"
    done
    kubectl get resourcequota --all-namespaces
}

run_tests() {
    print_section_header "Running component tests"
    bats "$CONFIG_DIR/test/"
}
