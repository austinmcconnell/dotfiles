#!/bin/bash

echo "Starting nginx container..."
docker run --rm --name nginx -d nginx

CONTAINER_IP=$(docker inspect nginx --format '{{.NetworkSettings.IPAddress}}')

echo "Pinging nginx container using IP address..."
if curl --silent "$CONTAINER_IP" | grep -q 'nginx'; then
    echo "Successfully pinged container"
    exit_code=0
else
    echo "Failed to ping container"
    exit_code=1
fi

echo "Stopping nginx container..."
docker stop nginx

exit "$exit_code"
