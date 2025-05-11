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

verify_node_reservations() {
    print_section_header "Verifying node resource reservations"

    echo "Waiting for nodes to be ready..."
    kubectl wait --for=condition=ready node --all --timeout=90s

    echo "Checking system reservations on nodes:"
    for node in $(kubectl get nodes -o name); do
        node_name=${node#node/}
        echo "Node: ${node_name}"

        echo "Allocatable Resources:"
        # Extract allocatable resources and convert memory to Gi with 2 decimal places
        kubectl get node "${node_name}" -o json |
            jq '.status.allocatable |
                {
                    cpu,
                    memory: (.memory |
                        if test("Ki$") then
                        (gsub("Ki$";"") | tonumber / 1048576 | (. * 100 | floor / 100) | tostring) + "Gi"
                        elif test("Mi$") then
                        (gsub("Mi$";"") | tonumber / 1024 | (. * 100 | floor / 100) | tostring) + "Gi"
                        else . end),
                    pods
                }' | jq '.'

        echo "System reserved settings:"
        docker exec "${node_name}" ps aux | grep kubelet | grep -o -- "--system-reserved=[^ ]*" |
            sed 's/--system-reserved=//' |
            tr ',' '\n' |
            jq -R 'split("=") | {(.[0]): .[1]}' |
            jq -s add || echo "System reserved not found in kubelet arguments"
        echo ""
    done

    echo "Node resource usage:"
    kubectl top nodes || echo "Metrics server not available yet. Run 'kubectl top nodes' later to check resource usage."
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

    # Add verification of node reservations
    verify_node_reservations
}

# Only run on macOS
if is-macos; then
    install_docker_mac_net_connect
fi

# Create the cluster
create_kind_cluster

# Update certificates
update_ca_certificates
