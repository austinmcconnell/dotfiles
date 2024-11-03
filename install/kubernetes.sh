#!/bin/bash

if is-executable kind; then
    echo "**************************************************"
    echo "Configuring kubernetes"
    echo "**************************************************"
else
    if is-macos; then
        echo "**************************************************"
        echo "Installing Kubernetes"
        echo "**************************************************"
        brew install kind kubectl kubectx helm mkcert
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

# Install Docker Mac Net Connect
# Allows connecting directly to Docker-for-Mac container via their IP address
# https://github.com/chipmk/docker-mac-net-connect
if brew services list | grep -q docker-mac-net-connect; then
    brew services info docker-mac-net-connect
else
    brew install chipmk/tap/docker-mac-net-connect
    sudo brew services start chipmk/tap/docker-mac-net-connect
fi

print_section_header() {
    echo "**************************************************"
    echo "$1"
    echo "**************************************************"
}

create_kind_cluster() {
    print_section_header "Creating kind cluster"
    kind create cluster \
        --wait 3m \
        --config "$DOTFILES_DIR/etc/kind/cluster-config.yaml" \
        --image "kindest/node:$KUBERNETES_VERSION"
    kubectl cluster-info --context kind-kind
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

install_ingress_nginx() {
    print_section_header "Install ingress-nginx"
    helm install \
        --wait \
        --timeout 5m \
        --namespace ingress-nginx \
        --create-namespace \
        --repo https://kubernetes.github.io/ingress-nginx \
        ingress-nginx ingress-nginx
    kubectl wait --namespace ingress-nginx \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=90s
}

install_prometheus() {
    print_section_header "Install prometheus stack"
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update
    helm install \
        --wait \
        --timeout 5m \
        --namespace monitoring \
        --create-namespace \
        --values "$DOTFILES_DIR/etc/kind/kube-prometheus-stack.yaml" \
        kind-prometheus prometheus-community/kube-prometheus-stack
    kubectl wait --namespace monitoring \
        --for=condition=ready pod \
        --selector=app=kube-prometheus-stack-operator \
        --timeout=90s
}

install_metallb() {
    print_section_header "Install metallb"
    # helpful link: https://gist.github.com/RafalSkolasinski/b41b790b1c575223251ff90311419863
    helm repo add metallb https://metallb.github.io/metallb
    helm repo update
    helm upgrade --install metallb metallb/metallb -n metallb-system --create-namespace
    kubectl rollout --namespace metallb-system status deployment metallb-controller

    # Gather network information
    kind_network=$(docker network inspect kind | jq --raw-output '.[0].IPAM.Config[1].Subnet')
    echo "Kind network: $kind_network"
    network_gateway=$(docker network inspect kind | jq --raw-output '.[0].IPAM.Config[1].Gateway')
    echo "Network gateway: $network_gateway"
    kind_container_ip=$(docker inspect kind-control-plane --format '{{.NetworkSettings.Networks.kind.IPAddress}}')
    echo "IP of container running kind: $kind_container_ip"

    # Set available IP addresses
    network_mask_start=$(echo "$kind_network" | cut -d/ -f 1 | sed -e 's/0/255/' | sed -e 's/0/1/')
    network_mask_end=$(echo "$kind_network" | cut -d/ -f 1 | sed -e 's/0/255/g')
    echo "Network mask: $network_mask_start-$network_mask_end"
    bat "$DOTFILES_DIR/etc/kind/metallb-ipaddresspool.yaml" |
        sed -e "s/1.1.1.1/$network_mask_start/" |
        sed -e "s/2.2.2.2/$network_mask_end/" |
        kubectl apply -f -

}

install_cert_manager() {
    print_section_header "Installing Cert Manager"
    helm repo add jetstack https://charts.jetstack.io --force-update
    helm install \
        --namespace cert-manager \
        --create-namespace \
        --version v1.16.1 \
        --values "$DOTFILES_DIR/etc/kind/cert-manager.yaml" \
        cert-manager jetstack/cert-manager
    kubectl rollout --namespace cert-manager status deployment cert-manager

    # Generate and install local CA
    mkcert -install

    # Add CA's certificate and key to kubernetes
    kubectl create secret tls mkcert-ca-key-pair \
        --key "$(mkcert -CAROOT)"/rootCA-key.pem \
        --cert "$(mkcert -CAROOT)"/rootCA.pem -n cert-manager

    # Tell cert-manager to use this to issue certificates
    kubectl apply -f "$DOTFILES_DIR/etc/kind/cert-manager-cluster-issuer.yaml"

}

existing_clusters=$(kind get clusters --quiet)

if [[ $existing_clusters =~ "kind" ]]; then
    kubectl cluster-info --context kind-kind
else
    create_kind_cluster

    update_ca_certificates

    install_metallb

    install_ingress_nginx

    install_prometheus

    install_cert_manager
fi
