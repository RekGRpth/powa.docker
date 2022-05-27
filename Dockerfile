FROM ghcr.io/rekgrpth/gost.docker:latest
ARG DOCKER_PYTHON_VERSION=3.10
CMD [ "gosu", "powa", "powa-web" ]
ENV GROUP=powa \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH="/usr/local/lib/python$DOCKER_PYTHON_VERSION:/usr/local/lib/python$DOCKER_PYTHON_VERSION/lib-dynload:/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages" \
    USER=powa
RUN set -eux; \
    apk update --no-cache; \
    apk upgrade --no-cache; \
    addgroup -S "$GROUP"; \
    adduser -S -D -G "$GROUP" -H -h "$HOME" -s /sbin/nologin "$USER"; \
    apk add --no-cache --virtual .build \
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
        py3-tornado \
        py3-wheel \
        python3-dev \
    ; \
    cd "$HOME"; \
    pip install --no-cache-dir --prefix /usr/local \
        powa-web \
        python-pcre \
    ; \
    cd /; \
    apk add --no-cache --virtual .powa \
        py3-greenlet \
        py3-psycopg2 \
        py3-sqlalchemy \
        py3-tornado \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | grep -v "^$" | grep -v -e libcrypto | sort -u | while read -r lib; do test -z "$(find /usr/local/lib -name "$lib")" && echo "so:$lib"; done) \
    ; \
    find /usr/local/bin -type f -exec strip '{}' \;; \
    find /usr/local/lib -type f -name "*.so" -exec strip '{}' \;; \
    apk del --no-cache .build; \
    rm -rf "$HOME" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    find /usr -type f -name "*.la" -delete; \
    find /usr -type f -name "*.pyc" -delete; \
    mkdir -p "$HOME"; \
    chown -R "$USER":"$GROUP" "$HOME"; \
    echo done
