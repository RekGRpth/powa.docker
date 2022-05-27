#!/bin/sh -eux

docker pull ghcr.io/rekgrpth/powa.docker
docker volume create powa
docker network create --attachable --opt com.docker.network.bridge.name=docker docker || echo $?
docker stop powa || echo $?
docker rm powa || echo $?
docker run \
    --detach \
    --env GROUP_ID=$(id -g) \
    --env LANG=ru_RU.UTF-8 \
    --env TZ=Asia/Yekaterinburg \
    --env USER_ID=$(id -u) \
    --hostname powa \
    --mount type=bind,source=/etc/certs,destination=/etc/certs,readonly \
    --mount type=bind,source=/run/postgresql,destination=/run/postgresql \
    --mount type=volume,source=powa,destination=/home \
    --name powa \
    --network name=docker \
    --restart always \
    ghcr.io/rekgrpth/powa.docker
