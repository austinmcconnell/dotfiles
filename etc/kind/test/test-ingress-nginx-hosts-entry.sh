#!/bin/bash

: "${LOCAL_DOMAIN:=dev.test}"

kubectl create deployment demo --image=httpd --port=80
kubectl expose deployment demo

kubectl create ingress demo --class=nginx --rule "$LOCAL_DOMAIN"/=demo:80

kubectl wait --for=condition=ready pod --selector=app=demo

sleep 3

echo "Pinging container at http://$LOCAL_DOMAIN"
if curl --connect-timeout 5 --retry 3 "http://$LOCAL_DOMAIN" | grep -q 'It works!'; then
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
