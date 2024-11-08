#!/bin/bash

: "${LOCAL_DOMAIN:=dev.test}"

kubectl create deployment demo --image=httpd --port=80
kubectl expose deployment demo

kubectl create ingress demo --class=nginx --rule "$LOCAL_DOMAIN"/=demo:80,tls="$LOCAL_DOMAIN" --annotation cert-manager.io/cluster-issuer=mkcert-issuer

kubectl wait --for=condition=ready pod --selector=app=demo
kubectl wait --for=condition=ready certificate "$LOCAL_DOMAIN"

sleep 3

echo "Pinging container at https://$LOCAL_DOMAIN"
if curl --connect-timeout 5 --retry 3 --verbose https://"$LOCAL_DOMAIN" 2>&1 | grep 'SSL certificate verify ok'; then
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
