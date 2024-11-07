#!/bin/bash

echo "Starting nginx container"
docker run --rm --name nginx -d nginx

CONTAINER_IP=$(docker inspect nginx --format '{{.NetworkSettings.IPAddress}}')

echo "Pinging container using conainer ip $CONTAINER_IP"
if curl --connect-timeout 5 --retry 3 "$CONTAINER_IP" | grep -q 'nginx'; then
    echo "Successfully pinged container"
    exit_code=0
else
    echo "Failed to ping container"
    exit_code=1
fi

echo "Stoping nginx container"
docker stop nginx

exit "$exit_code"
