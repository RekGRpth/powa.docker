#!/bin/sh -eux

apk update --no-cache
apk upgrade --no-cache
apk add --no-cache --virtual .build-deps \
    g++ \
    gcc \
    git \
    libpq-dev \
    linux-headers \
    make \
    musl-dev \
    pcre2-dev \
    pcre-dev \
    py3-greenlet \
    py3-pip \
    py3-psycopg2 \
    py3-sqlalchemy \
    py3-wheel \
    python3-dev \
;
