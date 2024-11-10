#!/bin/bash

kubectl create deployment demo --image=httpd --port=80
kubectl set resources deployment demo --containers httpd --limits=cpu=25m,memory=64Mi
kubectl expose deployment demo
kubectl autoscale deployment demo --cpu-percent=50 --min=1 --max=2

# Wait for metrics to be reported
kubectl wait --timeout=90s --for=jsonpath='{.status.currentMetrics[0].resource.current.averageUtilization}' hpa demo

# Create client to generate load
kubectl run -i --tty load-generator --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://demo; done" >/dev/null 2>&1 &

echo "Waiting for pods to scale"
if kubectl wait --timeout=90s --for=jsonpath='{.status.desiredReplicas}'=2 hpa demo >/dev/null; then
    echo "Successfully scaled pods"
    exit_code=0
else
    echo "Failed to scale pods"
    exit_code=1
fi

kubectl delete pod load-generator --now
kubectl delete hpa demo
kubectl delete service demo
kubectl delete deployment demo

exit "$exit_code"
