#!/bin/bash

set -e

# Source common functions if not already sourced
if [ -z "$KUBERNETES_VERSION" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/common.sh"
fi

install_docker_mac_net_connect() {
    # Allows connecting directly to Docker-for-Mac container via their IP address
    # https://github.com/chipmk/docker-mac-net-connect

    print_section_header "Installing docker-mac-net-connect"

    if brew services list | grep -q docker-mac-net-connect; then
        brew services info docker-mac-net-connect
    else
        brew install chipmk/tap/docker-mac-net-connect
        sudo brew services start chipmk/tap/docker-mac-net-connect
    fi

    print_section_header "Testing docker-mac-net-connect"
    sh "$DOTFILES_DIR/etc/kind/test/test-docker-mac-net-connect.sh"
}

create_kind_cluster() {
    print_section_header "Creating kind cluster"

    existing_clusters=$(kind get clusters --quiet)

    if [[ $existing_clusters =~ "kind" ]]; then
        kubectl cluster-info --context kind-kind
    else
        if docker network ls --filter name=kind | grep --quiet "kind"; then
            echo "Removing old kind docker network"
            # If the old kind network is not removed first, sometimes I would only get
            # IPV6 addresses assigned and things below that depend on IPV4 would fail
            docker network rm kind
        fi
        kind create cluster \
            --wait 3m \
            --config "$DOTFILES_DIR/etc/kind/cluster-config.yaml" \
            --image "kindest/node:$KUBERNETES_VERSION"
        kubectl cluster-info --context kind-kind
    fi

    print_section_header "Testing NodePort"
    sh "$DOTFILES_DIR/etc/kind/test/test-node-port.sh"
}

# Only run on macOS
if is-macos; then
    install_docker_mac_net_connect
fi

# Create the cluster
create_kind_cluster

# Update certificates
update_ca_certificates
