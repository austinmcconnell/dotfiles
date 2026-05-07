#!/usr/bin/env bats

load '/opt/homebrew/lib/bats-support/load.bash'
load '/opt/homebrew/lib/bats-assert/load.bash'

@test "keda operator pod is running" {
    run kubectl wait --for=condition=ready pod \
        -l app=keda-operator -n keda --timeout=60s
    assert_success
}

@test "keda metrics server pod is running" {
    run kubectl wait --for=condition=ready pod \
        -l app=keda-operator-metrics-apiserver -n keda --timeout=60s
    assert_success
}

@test "keda CRDs are installed" {
    run kubectl get crd scaledobjects.keda.sh
    assert_success
}
