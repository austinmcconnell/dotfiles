#!/bin/bash

# Common variables
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
CONFIG_DIR="$DOTFILES_DIR/etc/kind"
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
    host_name=$1

    ip_address=$(kubectl get services \
        --namespace ingress-nginx \
        ingress-nginx-controller \
        --output jsonpath='{.status.loadBalancer.ingress[0].ip}')

    if [ -z "$ip_address" ]; then
        echo "Cannot find ip address of load balancer. Aborting..."
        exit 1
    fi

    # find existing instances and save the line numbers
    host_matches_in_hosts="$(grep -n "$host_name" /etc/hosts | cut -f 1 -d :)"
    ip_matches_in_hosts="$(grep -n "$ip_address" /etc/hosts | cut -f 1 -d :)"

    if [ -n "$host_matches_in_hosts" ]; then
        echo "Hosts entry already exists for $host_name"
    else
        if [ -n "$ip_matches_in_hosts" ]; then
            echo "Updating existing hosts entry. Please enter your password, if requested."
            # iterate over the line numbers on which matches were found
            while read -r line_number; do
                # append the host_name to the end of the linethe text of each line with the desired host entry
                sudo sed -i '' "${line_number}s/$/, ${host_name}/" /etc/hosts
            done <<<"$ip_matches_in_hosts"
        else
            host_entry="${ip_address} ${host_name}"
            filepath=$(readlink -f -- "$0")
            echo "Adding new hosts entry. Please enter your password, if requested."
            echo -e "\n# Added by $filepath" | sudo tee -a /etc/hosts >/dev/null
            echo "$host_entry" | sudo tee -a /etc/hosts >/dev/null
            echo "# End of section" | sudo tee -a /etc/hosts >/dev/null
        fi
    fi
}

update_ca_certificates() {
    print_section_header "Updating mounted certificates"
    nodes=$(kind get nodes)
    for node in $nodes; do
        echo "Updating certs on node: $node"
        docker exec "$node" update-ca-certificates
        docker exec "$node" systemctl restart containerd
    done
}

update_helm_repos() {
    print_section_header "Updating helm repos"
    helm repo update
}
