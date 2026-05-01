#!/usr/bin/env bats

load '/opt/homebrew/lib/bats-support/load.bash'
load '/opt/homebrew/lib/bats-assert/load.bash'

LOCAL_DOMAIN="${LOCAL_DOMAIN:-dev.test}"

setup_file() {
    kubectl create deployment demo --image=httpd --port=80
    kubectl expose deployment demo
    kubectl create ingress demo --class=nginx --rule="${LOCAL_DOMAIN}/=demo:80"
    kubectl wait --for=condition=ready pod --selector=app=demo --timeout=60s
    sleep 3
}

teardown_file() {
    kubectl delete ingress demo --ignore-not-found
    kubectl delete service demo --ignore-not-found
    kubectl delete deployment demo --ignore-not-found
}

@test "ingress routes HTTP traffic via hosts entry" {
    run curl -sf --connect-timeout 5 --retry 3 "http://${LOCAL_DOMAIN}"
    assert_success
    assert_output --partial "It works!"
}
