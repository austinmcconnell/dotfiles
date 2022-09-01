#!/bin/sh

if is-executable microk8s; then
    echo "**************************************************"
    echo "Configuring kubernetes"
    echo "**************************************************"
    microk8s start
else
    KUBERNETES_VERSION=1.22/stable
    if is-macos; then
        echo "**************************************************"
        echo "Installing Kubernetes"
        echo "**************************************************"
        brew install ubuntu/microk8s/microk8s kubectl kubectx
        microk8s install --cpu=4 --mem=8 --channel=$KUBERNETES_VERSION
        # If the install step fails, try disabling stealth mode in Security & Privacy -> Firewall -> Firewall Options, install again, then re-enable stealth mode
    elif is-debian; then
        echo "**************************************************"
        echo "Installing Kubernetes"
        echo "**************************************************"
        sudo snap install microk8s --classic --channel=$KUBERNETES_VERSION
        sudo apt install -y kubectl
    else
        echo "**************************************************"
        echo "Skipping Kubernetes installation: Unidentified OS"
        echo "**************************************************"
        return
    fi
fi

microk8s status --wait-ready

microk8s enable dashboard dns registry istio ingress prometheus

kubectl config set-cluster microk8s \
    --server=$(microk8s kubectl config view --raw -o 'jsonpath={.clusters[0].cluster.server}') \
    --insecure-skip-tls-verify
kubectl config set-credentials microk8s-admin \
    --token=$(microk8s kubectl config view --raw -o 'jsonpath={.users[0].user.token}')
kubectl config set-context microk8s --cluster=microk8s --namespace=default --user=microk8s-admin

microk8s stop
