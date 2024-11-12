#!/bin/bash

set -e

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
        return
    fi
fi

KUBERNETES_VERSION=v1.29.2

: "${LOCAL_DOMAIN:=dev.test}"

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

add_hosts_entries() {
    print_section_header "Adding /etc/hosts entries"
    update_etc_hosts "$LOCAL_DOMAIN"
    update_etc_hosts "prometheus.$LOCAL_DOMAIN"
    update_etc_hosts "grafana.$LOCAL_DOMAIN"
    update_etc_hosts "alertmanager.$LOCAL_DOMAIN"
}

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

    NAME=$1

    if kind get clusters --quiet | grep --quiet "$NAME"; then
        echo "kind cluster already created"
        kubectl cluster-info --context "kind-$NAME"
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
            --image "kindest/node:$KUBERNETES_VERSION" \
            --name "$NAME"
        kubectl cluster-info --context "kind-$NAME"

        update_ca_certificates "$NAME"
    fi
}

update_ca_certificates() {
    print_section_header "Updating mounted certificates"
    nodes=$(kind get nodes --name "$1")
    for node in $nodes; do
        echo "Updating certs on node: $node"
        docker exec "$node" update-ca-certificates
        docker exec "$node" systemctl restart containerd
    done
}

configure_metallb() {
    print_section_header "Configuring metallb"
    # helpful link: https://gist.github.com/RafalSkolasinski/b41b790b1c575223251ff90311419863

    kubectl rollout --namespace metallb-system status deployment metallb-controller

    if kubectl get --namespace metallb-system ipaddresspools.metallb.io | grep --quiet local-pool; then
        echo "IPAddressPool and L2Advertisement already created"
    else
        SUBNET=$(docker network inspect kind | jq --raw-output '.[0].IPAM.Config[1].Subnet') \
            yq '(. | select(.kind == "IPAddressPool") | .spec.addresses.[0]) = strenv(SUBNET)' etc/kind/manifests/metallb-ipaddresspool.yaml |
            kubectl apply -f -
    fi
}

configure_cert_manager() {
    print_section_header "Configure cert-manager"

    if kubectl get secrets --namespace cert-manager | grep --quiet mkcert-ca-key-pair; then
        echo "mkcert-ca-key-pair already exists"
    else
        # Generate and install local CA
        mkcert -install

        # Add CA's certificate and key to kubernetes
        kubectl create secret tls mkcert-ca-key-pair \
            --key "$(mkcert -CAROOT)"/rootCA-key.pem \
            --cert "$(mkcert -CAROOT)"/rootCA.pem --namespace cert-manager

        # Tell cert-manager to use this to issue certificates
        kubectl apply -f "$DOTFILES_DIR/etc/kind/manifests/cert-manager-cluster-issuer.yaml"
    fi
}

run_tests() {
    print_section_header "Testing NodePort"
    sh "$DOTFILES_DIR/etc/kind/test/test-node-port.sh"

    print_section_header "Testing metallb"
    sh "$DOTFILES_DIR/etc/kind/test/test-metallb.sh"

    print_section_header "Testing ingress-nginx"
    sh "$DOTFILES_DIR/etc/kind/test/test-ingress-nginx-port-forward.sh"
    sh "$DOTFILES_DIR/etc/kind/test/test-ingress-nginx-hosts-entry.sh"

    print_section_header "Testing cert-manager"
    sh "$DOTFILES_DIR/etc/kind/test/test-cert-manager.sh"

    print_section_header "Testing metrics-server"
    sh "$DOTFILES_DIR/etc/kind/test/test-metrics-server.sh"
    sh "$DOTFILES_DIR/etc/kind/test/test-horizontal-pod-autoscaler.sh"
}

# install_docker_mac_net_connect

create_kind_cluster "kind"

helmsman --apply -f etc/kind/cluster-infrastructure.toml --target metallb

configure_metallb

LOCAL_DOMAIN=$LOCAL_DOMAIN helmsman --apply --subst-env-values -f etc/kind/cluster-infrastructure.toml

configure_cert_manager

add_hosts_entries

run_tests

helmsman --check-for-chart-updates
