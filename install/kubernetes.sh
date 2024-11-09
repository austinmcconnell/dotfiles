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
    print_section_header "Installing ingress-nginx"

    if helm repo list | grep --quiet kubernetes; then
        echo "Helm repo already added"
    else
        helm repo add kubernetes https://kubernetes.github.io/ingress-nginx
        helm repo update
    fi

    if helm list --namespace ingress-nginx | grep --quiet ingress-nginx; then
        echo "ingress-nginx already installed"
        if [[ -n $(helm diff upgrade --reuse-values --namespace ingress-nginx ingress-nginx kubernetes/ingress-nginx) ]]; then
            echo "Upgrading ingress-nginx"
            helm upgrade --reuse-values --namespace ingress-nginx ingress-nginx kubernetes/ingress-nginx
        else
            echo "No upgrade needed"
        fi
    else
        helm install \
            --wait \
            --timeout 5m \
            --namespace ingress-nginx \
            --create-namespace \
            ingress-nginx kubernetes/ingress-nginx
        kubectl wait --namespace ingress-nginx \
            --for=condition=ready pod \
            --selector=app.kubernetes.io/component=controller \
            --timeout=90s

        update_etc_hosts "$LOCAL_DOMAIN"
    fi

    print_section_header "Testing ingress-nginx"
    sh "$DOTFILES_DIR/etc/kind/test/test-ingress-nginx-port-forward.sh"
    sh "$DOTFILES_DIR/etc/kind/test/test-ingress-nginx-hosts-entry.sh"
}

install_prometheus() {
    print_section_header "Install prometheus stack"

    if helm repo list | grep --quiet prometheus-community; then
        echo "Helm repo already added"
    else
        helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
        helm repo update
    fi

    if helm list --namespace monitoring | grep --quiet prometheus; then
        echo "prometheus already installed"
    else
        sed 's/.example/.'"$LOCAL_DOMAIN"'/g' "$DOTFILES_DIR/etc/kind/kube-prometheus-stack.yaml" |
            helm install \
                --wait \
                --timeout 5m \
                --namespace monitoring \
                --create-namespace \
                prometheus prometheus-community/kube-prometheus-stack \
                --values -
        kubectl wait --namespace monitoring \
            --for=condition=ready pod \
            --selector=app=kube-prometheus-stack-operator \
            --timeout=90s

        update_etc_hosts "prometheus.$LOCAL_DOMAIN"
        update_etc_hosts "grafana.$LOCAL_DOMAIN"
        update_etc_hosts "alertmanager.$LOCAL_DOMAIN"
    fi
}

install_metallb() {
    print_section_header "Installing metallb"
    # helpful link: https://gist.github.com/RafalSkolasinski/b41b790b1c575223251ff90311419863

    if helm repo list | grep --quiet metallb; then
        echo "Helm repo already added"
    else
        helm repo add metallb https://metallb.github.io/metallb
        helm repo update
    fi

    if helm list --namespace metallb-system | grep --quiet metallb; then
        echo "metallb already installed"
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

install_cert_manager() {
    print_section_header "Installing cert-manager"

    if helm repo list | grep --quiet jetstack; then
        echo "Helm repo already added"
    else
        helm repo add jetstack https://charts.jetstack.io
        helm repo update
    fi

    if helm list --namespace cert-manager | grep --quiet cert-manager; then
        echo "cert-manager already installed"
        # helm diff support for --reset-then-reuse-values is merged in but not released yet
        # https://github.com/databus23/helm-diff/pull/634
        # if [[ -n $(helm diff upgrade --reset-then-reuse-values --namespace cert-manager cert-manager jetstack/cert-manager) ]]; then
        #     echo "Upgrading cert-manager"
        #     helm upgrade --reset-then-reuse-values --namespace cert-manager cert-manager jetstack/cert-manager
        # else
        #     echo "No upgrade needed"
        # fi
    else
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
    fi

    print_section_header "Testing cert-manager"
    sh "$DOTFILES_DIR/etc/kind/test/test-cert-manager.sh"
}

update_helm_repos() {
    print_section_header "Updating helm repos"
    helm repo update
}

install_helm_plugins() {
    print_section_header "Installing helm plugins"

    if helm plugin list | grep --quiet diff; then
        echo "diff plugin already added"
    else
        helm plugin install https://github.com/databus23/helm-diff
    fi
}

install_docker_mac_net_connect

create_kind_cluster

update_ca_certificates

install_helm_plugins

update_helm_repos

install_metallb

install_ingress_nginx

install_cert_manager

install_prometheus
