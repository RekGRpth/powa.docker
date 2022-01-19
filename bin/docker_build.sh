#!/bin/sh -eux

cd "$HOME"
pip install --no-cache-dir --prefix /usr/local \
    powa-web \
    python-pcre \
    tornado==5.1 \
;
