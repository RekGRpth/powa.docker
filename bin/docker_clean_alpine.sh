#!/bin/sh -eux

cd /
apk add --no-cache --virtual .powa-rundeps \
        py3-greenlet \
        py3-psycopg2 \
        py3-sqlalchemy \
        su-exec \
        uwsgi-python3 \
    $(scanelf --needed --nobanner --format '%n#p' --recursive /usr/local | tr ',' '\n' | sort -u | while read -r lib; do test ! -e "/usr/local/lib/$lib" && echo "so:$lib"; done) \
;
find /usr/local/bin -type f -exec strip '{}' \;
find /usr/local/lib -type f -name "*.so" -exec strip '{}' \;
apk del --no-cache .build-deps
