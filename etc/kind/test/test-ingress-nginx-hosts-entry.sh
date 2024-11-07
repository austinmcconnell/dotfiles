#!/bin/bash

: "${LOCAL_DOMAIN:=dev.localhost}"

kubectl create deployment demo --image=httpd --port=80
kubectl expose deployment demo

kubectl create ingress demo --class=nginx --rule "$LOCAL_DOMAIN"/=demo:80

kubectl wait --for=condition=ready pod --selector=app=demo

sleep 4

if curl --connect-timeout 5 --retry 3 --silent "http://$LOCAL_DOMAIN" | grep -q 'It works!'; then
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
