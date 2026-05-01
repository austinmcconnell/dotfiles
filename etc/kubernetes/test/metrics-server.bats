#!/usr/bin/env bats

load '/opt/homebrew/lib/bats-support/load.bash'
load '/opt/homebrew/lib/bats-assert/load.bash'

setup_file() {
    kubectl create deployment demo --image=httpd --port=80
    kubectl set resources deployment demo --containers=httpd --limits=cpu=100m,memory=512Mi
    kubectl expose deployment demo
    kubectl autoscale deployment demo --cpu-percent=50 --min=1 --max=5
}

teardown_file() {
    kubectl delete hpa demo --ignore-not-found
    kubectl delete service demo --ignore-not-found
    kubectl delete deployment demo --ignore-not-found
}

@test "metrics-server reports HPA metrics" {
    run kubectl wait --timeout=90s \
        --for=jsonpath='{.status.currentMetrics[0].resource.current.averageUtilization}' \
        hpa demo
    assert_success
}
