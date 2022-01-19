#!/bin/sh -eux

apk update --no-cache
apk upgrade --no-cache
apk add --no-cache --virtual .build-deps \
    g++ \
    gcc \
    git \
    linux-headers \
    make \
    musl-dev \
    pcre2-dev \
    pcre-dev \
    postgresql-dev \
    py3-pip \
    py3-wheel \
    python3-dev \
    py3-greenlet \
    py3-psycopg2 \
    py3-sqlalchemy \
;
