#!/usr/bin/env bats

load '/opt/homebrew/lib/bats-support/load.bash'
load '/opt/homebrew/lib/bats-assert/load.bash'

@test "ingress-nginx release is deployed" {
    run helm status ingress-nginx --namespace ingress-nginx --output json
    assert_success
    run bash -c "helm status ingress-nginx -n ingress-nginx -o json | jq -r '.info.status'"
    assert_output "deployed"
}

@test "cert-manager release is deployed" {
    run helm status cert-manager --namespace cert-manager --output json
    assert_success
    run bash -c "helm status cert-manager -n cert-manager -o json | jq -r '.info.status'"
    assert_output "deployed"
}

@test "metrics-server release is deployed" {
    run helm status metrics-server --namespace monitoring --output json
    assert_success
    run bash -c "helm status metrics-server -n monitoring -o json | jq -r '.info.status'"
    assert_output "deployed"
}

@test "prometheus release is deployed" {
    run helm status prometheus --namespace monitoring --output json
    assert_success
    run bash -c "helm status prometheus -n monitoring -o json | jq -r '.info.status'"
    assert_output "deployed"
}
