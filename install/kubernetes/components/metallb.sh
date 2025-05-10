#!/bin/bash

set -e

# Source common functions if not already sourced
if [ -z "$KUBERNETES_VERSION" ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/../common.sh"
fi

install_metallb() {
    print_section_header "Installing metallb"
    # helpful link: https://gist.github.com/RafalSkolasinski/b41b790b1c575223251ff90311419863

    if helm repo list | grep --quiet metallb; then
        echo "metallb repo already added"
    else
        helm repo add metallb https://metallb.github.io/metallb
        helm repo update
    fi

    if helm list --namespace metallb-system | grep --quiet metallb; then
        echo "metallb already installed"
        if [[ -n $(helm diff upgrade --reuse-values --namespace metallb-system metallb metallb/metallb) ]]; then
            echo "Upgrading metallb"
            helm upgrade --reuse-values --namespace metallb-system metallb metallb/metallb
        else
            echo "No upgrade needed"
        fi
    else
        helm install metallb metallb/metallb -n metallb-system --create-namespace
        kubectl rollout --namespace metallb-system status deployment metallb-controller

        # Gather network information
        kind_network=$(docker network inspect kind | jq --raw-output '.[0].IPAM.Config[1].Subnet')
        echo "Kind network: $kind_network"
        network_gateway=$(docker network inspect kind | jq --raw-output '.[0].IPAM.Config[1].Gateway')
        echo "Network gateway: $network_gateway"
        kind_container_ip=$(docker inspect kind-control-plane --format '{{.NetworkSettings.Networks.kind.IPAddress}}')
        echo "IP of container running kind: $kind_container_ip"

        # Set available IP addresses
        network_mask_start=$(echo "$kind_network" | cut -d / -f 1 | sed -e 's/\.0/\.255/' | sed -e 's/\.0/\.1/')
        network_mask_end=$(echo "$kind_network" | cut -d / -f 1 | sed -e 's/\.0/\.255/g')
        echo "Network mask: $network_mask_start-$network_mask_end"

        bat "$DOTFILES_DIR/etc/kind/metallb-ipaddresspool.yaml" |
            sed -e "s/1.1.1.1/$network_mask_start/" |
            sed -e "s/2.2.2.2/$network_mask_end/" |
            kubectl apply -f -
    fi

    print_section_header "Testing metallb"
    sh "$DOTFILES_DIR/etc/kind/test/test-metallb.sh"
}

# Install metallb
install_metallb
