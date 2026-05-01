#!/usr/bin/env bats

load '/opt/homebrew/lib/bats-support/load.bash'
load '/opt/homebrew/lib/bats-assert/load.bash'

LOCAL_DOMAIN="${LOCAL_DOMAIN:-local.dev}"

setup_file() {
    kubectl create deployment demo --image=httpd --port=80
    kubectl expose deployment demo
    kubectl create ingress demo --class=nginx \
        --rule="${LOCAL_DOMAIN}/=demo:80,tls=${LOCAL_DOMAIN}" \
        --annotation cert-manager.io/cluster-issuer=mkcert-issuer
    kubectl wait --for=condition=ready pod --selector=app=demo --timeout=60s
    kubectl wait --for=condition=ready certificate "${LOCAL_DOMAIN}" --timeout=60s
    sleep 3
}

teardown_file() {
    kubectl delete ingress demo --ignore-not-found
    kubectl delete service demo --ignore-not-found
    kubectl delete deployment demo --ignore-not-found
}

@test "cert-manager issues a valid TLS certificate" {
    run curl -sf --connect-timeout 5 --retry 3 --verbose "https://${LOCAL_DOMAIN}" 2>&1
    assert_output --partial "SSL certificate verify ok"
}
