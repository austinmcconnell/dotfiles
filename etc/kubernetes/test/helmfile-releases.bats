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

@test "loki release is deployed" {
    run helm status loki --namespace loki --output json
    assert_success
    run bash -c "helm status loki -n loki -o json | jq -r '.info.status'"
    assert_output "deployed"
}

@test "alloy release is deployed" {
    run helm status alloy --namespace loki --output json
    assert_success
    run bash -c "helm status alloy -n loki -o json | jq -r '.info.status'"
    assert_output "deployed"
}

@test "podinfo-backend release is deployed" {
    run helm status podinfo-backend --namespace podinfo --output json
    assert_success
    run bash -c "helm status podinfo-backend -n podinfo -o json | jq -r '.info.status'"
    assert_output "deployed"
}

@test "podinfo-frontend release is deployed" {
    run helm status podinfo-frontend --namespace podinfo --output json
    assert_success
    run bash -c "helm status podinfo-frontend -n podinfo -o json | jq -r '.info.status'"
    assert_output "deployed"
}
