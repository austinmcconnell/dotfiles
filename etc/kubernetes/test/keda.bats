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

@test "keda-demo-worker ScaledObject is ready" {
    run kubectl get scaledobject keda-demo-worker -n podinfo \
        -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}'
    assert_success
    assert_output "True"
}

@test "keda-demo-worker is scaled to zero when queue is empty" {
    run kubectl get deployment keda-demo-worker -n podinfo \
        -o jsonpath='{.spec.replicas}'
    assert_success
    assert_output "0"
}

@test "keda ServiceMonitors have release label for Prometheus discovery" {
    run bash -c "kubectl get servicemonitor -n keda -o jsonpath='{.items[*].metadata.labels.release}'"
    assert_success
    assert_output --regexp "^(prometheus )*prometheus$"
}

@test "keda metrics are being scraped by Prometheus" {
    run bash -c "kubectl exec -n monitoring -c grafana \
        \$(kubectl get pod -n monitoring -l app.kubernetes.io/name=grafana -o name) \
        -- wget -qO- 'http://prometheus-kube-prometheus-prometheus.monitoring:9090/api/v1/query?query=keda_scaler_active' \
        | python3 -c \"import sys,json; print(json.load(sys.stdin)['status'])\""
    assert_success
    assert_output "success"
}

@test "keda Grafana dashboard is provisioned" {
    run bash -c "kubectl exec -n monitoring -c grafana \
        \$(kubectl get pod -n monitoring -l app.kubernetes.io/name=grafana -o name) \
        -- ls /var/lib/grafana/dashboards/default/keda-scaledobject.json"
    assert_success
}
