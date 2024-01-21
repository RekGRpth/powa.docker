#!/bin/sh -eux

docker build --tag "ghcr.io/rekgrpth/powa.docker:${INPUTS_BRANCH:-latest}" $(env | grep -E '^DOCKER_' | grep -v ' ' | sort -u | sed 's@^@--build-arg @g' | paste -s -d ' ') --file "${INPUTS_DOCKERFILE:-Dockerfile}" . 2>&1 | tee build.log
