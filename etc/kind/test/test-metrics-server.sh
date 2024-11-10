#!/bin/bash

kubectl create deployment demo --image=httpd --port=80
kubectl set resources deployment demo --containers httpd --limits=cpu=100m,memory=512Mi
kubectl expose deployment demo
kubectl autoscale deployment demo --cpu-percent=50 --min=1 --max=5

echo "Waiting for hpa metrics..."
if kubectl wait --timeout=90s --for=jsonpath='{.status.currentMetrics[0].resource.current.averageUtilization}' hpa demo >/dev/null; then
    echo "Detected hpa metrics"
    exit_code=0
else
    echo "Failed to detect hpa metrics"
    exit_code=1
fi

kubectl delete hpa demo
kubectl delete service demo
kubectl delete deployment demo

exit "$exit_code"
