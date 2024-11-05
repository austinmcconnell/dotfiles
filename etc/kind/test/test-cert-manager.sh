#!/bin/bash

kubectl create deployment demo --image=httpd --port=80
kubectl expose deployment demo

kubectl create ingress demo --class=nginx --rule dev.local/=demo:80,tls=dev.local --annotation cert-manager.io/cluster-issuer=mkcert-issuer

kubectl wait --for=condition=ready pod --selector=app=demo
kubectl wait --for=condition=ready certificate dev.local

if curl --verbose https://dev.local 2>&1 | grep 'SSL certificate verify ok'; then
    echo "Successfully pinged container"
    exit_code=0
else
    echo "Failed to ping container"
    exit_code=1
fi

kubectl delete ingress demo
kubectl delete service demo
kubectl delete deployment demo

exit "$exit_code"
