#!/usr/bin/env bats

load '/opt/homebrew/lib/bats-support/load.bash'
load '/opt/homebrew/lib/bats-assert/load.bash'

LOCAL_DOMAIN="${LOCAL_DOMAIN:-dev.test}"

@test "prometheus is reachable" {
    run curl -sf --connect-timeout 5 --retry 3 -k "https://prometheus.${LOCAL_DOMAIN}"
    assert_success
}

@test "grafana is reachable" {
    run curl -sf --connect-timeout 5 --retry 3 -k "https://grafana.${LOCAL_DOMAIN}"
    assert_success
}

@test "alertmanager is reachable" {
    run curl -sf --connect-timeout 5 --retry 3 -k "https://alertmanager.${LOCAL_DOMAIN}"
    assert_success
}
