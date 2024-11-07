#!/bin/bash

kubectl create deployment demo --image=httpd --port=80
kubectl expose deployment demo
kubectl create ingress demo-localhost --class=nginx --rule="demo.localdev.me/*=demo:80"

kubectl wait --for=condition=ready pod --selector=app=demo

# Test the ingress bypassing the hosts file entry
kubectl port-forward --namespace=ingress-nginx service/ingress-nginx-controller 8080:80 >/dev/null 2>&1 &
pid=$!
echo "port-forward pid: $pid"

# Give port forward time to come up
sleep 3

echo "Pinging container using port foward"
if curl --connect-timeout 5 --retry 3 --resolve demo.localdev.me:8080:127.0.0.1 http://demo.localdev.me:8080 | grep -q 'It works!'; then
    echo "Successfully pinged container"
    exit_code=0
else
    echo "Failed to ping container"
    exit_code=1
fi

echo "killing $pid"
kill $pid
echo "port-forward shut down"

kubectl delete ingress demo-localhost
kubectl delete service demo
kubectl delete deployment demo

exit "$exit_code"
