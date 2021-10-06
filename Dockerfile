FROM ghcr.io/rekgrpth/gost.docker
ARG PYTHON_VERSION=3.9
ENV GROUP=powa \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH="/usr/local/lib/python${PYTHON_VERSION}:/usr/local/lib/python${PYTHON_VERSION}/lib-dynload:/usr/local/lib/python${PYTHON_VERSION}/site-packages" \
    USER=powa
RUN set -eux; \
    addgroup -S "${GROUP}"; \
    adduser -D -S -h "${HOME}" -s /sbin/nologin -G "${GROUP}" "${USER}"; \
    ln -s pip3 /usr/bin/pip; \
    ln -s pydoc3 /usr/bin/pydoc; \
    ln -s python3 /usr/bin/python; \
    ln -s python3-config /usr/bin/python-config; \
    apk update --no-cache; \
    apk upgrade --no-cache; \
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
    ; \
    cd "${HOME}"; \
    pip install --no-cache-dir --ignore-installed --prefix /usr/local \
        greenlet \
        powa-web \
        psycopg2 \
        python-pcre \
#        setuptools \
        sqlalchemy \
        tornado \
        uwsgi \
    ; \
    cd /; \
    apk add --no-cache --virtual .pgadmin-rundeps \
        su-exec \
        $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | while read -r lib; do test ! -e "/usr/local/lib/$lib" && echo "so:$lib"; done) \
    ; \
    find /usr/local/bin -type f -exec strip '{}' \;; \
    find /usr/local/lib -type f -name "*.so" -exec strip '{}' \;; \
    apk del --no-cache .build-deps; \
    find /usr -type f -name "*.pyc" -delete; \
    find /usr -type f -name "*.a" -delete; \
    find /usr -type f -name "*.la" -delete; \
    ln -fs /usr/local/lib/python${PYTHON_VERSION}/site-packages/powa/powa.wsgi wsgi.py; \
    echo done
