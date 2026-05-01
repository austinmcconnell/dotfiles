#!/usr/bin/env bats

load '/opt/homebrew/lib/bats-support/load.bash'
load '/opt/homebrew/lib/bats-assert/load.bash'

@test "alloy pods are ready on all nodes" {
    run kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=alloy \
        -n loki --timeout=60s
    assert_success
}

@test "alloy is collecting logs" {
    kubectl -n loki port-forward svc/loki 3100:3100 &
    local pf_pid=$!
    sleep 2
    run curl -sf --connect-timeout 5 "http://localhost:3100/loki/api/v1/labels"
    kill "$pf_pid" 2>/dev/null || true
    assert_success
    assert_output --partial "namespace"
}
