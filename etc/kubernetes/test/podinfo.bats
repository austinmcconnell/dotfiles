#!/usr/bin/env bats

load '/opt/homebrew/lib/bats-support/load.bash'
load '/opt/homebrew/lib/bats-assert/load.bash'

LOCAL_DOMAIN="${LOCAL_DOMAIN:-dev.test}"

@test "podinfo frontend is reachable via ingress" {
    run curl -sf --connect-timeout 5 --retry 3 -k "https://podinfo.${LOCAL_DOMAIN}"
    assert_success
}

@test "podinfo backend is ready" {
    run kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=podinfo-backend \
        -n podinfo --timeout=60s
    assert_success
}

@test "podinfo frontend can reach backend" {
    run curl -sf --connect-timeout 5 -k -X POST -d '{"test": true}' \
        "https://podinfo.${LOCAL_DOMAIN}/echo"
    assert_success
}
