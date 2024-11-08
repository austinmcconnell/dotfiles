#!/bin/bash

kubectl create deployment demo --image=httpd --port=80
kubectl expose deployment demo --type NodePort

kubectl wait --for=condition=ready pod --selector=app=demo

NODE_PORT=$(kubectl get service demo -o jsonpath='{.spec.ports[0].nodePort}')
echo "Node Port: $NODE_PORT"

NODE_IP=$(kubectl get nodes --output jsonpath='{.items[0].status.addresses[0].address}')
echo "Node IP: $NODE_IP"

echo "Pinging container using $NODE_IP:$NODE_PORT"
if curl --connect-timeout 5 --retry 3 "$NODE_IP:$NODE_PORT" | grep -q 'It works!'; then
    echo "Successfully pinged container"
    exit_code=0
else
    echo "Failed to ping container"
    exit_code=1
fi

kubectl delete service demo
kubectl delete deployment demo

exit "$exit_code"
