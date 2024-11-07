#!/bin/bash

kubectl create deployment demo --image=httpd --port=80
kubectl expose deployment demo --type LoadBalancer

kubectl wait --for=jsonpath='{.status.loadBalancer.ingress[0].ip}' service/demo

LOADBALANCER_IP=$(kubectl get services \
    demo \
    --output jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "LoadBalancer IP: $LOADBALANCER_IP"

echo "Pinging container using LoadBalancer ip $LOADBALANCER_IP"
if curl --connect-timeout 5 --retry 3 "$LOADBALANCER_IP" | grep -q 'It works!'; then
    echo "Successfully pinged container"
    exit_code=0
else
    echo "Failed to ping container"
    exit_code=1
fi

kubectl delete service demo
kubectl delete deployment demo

exit "$exit_code"
