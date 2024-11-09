#!/bin/bash

ping_by_container_ip() {
    echo "Pinging container using conainer ip $CONTAINER_IP"
    if curl --connect-timeout 5 --retry 3 "$CONTAINER_IP" | grep -q 'nginx'; then
        echo "Successfully pinged container"
        exit_code=0
    else
        echo "Failed to ping container"
        exit_code=1
    fi
}

echo "Starting nginx container"
docker run --rm --name nginx -d nginx

CONTAINER_IP=$(docker inspect nginx --format '{{.NetworkSettings.IPAddress}}')

ping_by_container_ip

if ((exit_code > 0)); then
    echo "docker-mac-net-connect might be stuck. Enter password to try restarting service"
    sudo brew services restart docker-mac-net-connect
    ping_by_container_ip
fi

echo "Stoping nginx container"
docker stop nginx

exit "$exit_code"
