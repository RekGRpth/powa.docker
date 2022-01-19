ARG DOCKER_FROM=gost.docker:latest
FROM "ghcr.io/rekgrpth/$DOCKER_FROM"
ADD bin /usr/local/bin
ARG DOCKER_BUILD=build
ARG DOCKER_PYTHON_VERSION=3.9
ENV GROUP=powa \
    PYTHONIOENCODING=UTF-8 \
    PYTHONPATH="/usr/local/lib/python$DOCKER_PYTHON_VERSION:/usr/local/lib/python$DOCKER_PYTHON_VERSION/lib-dynload:/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages" \
    USER=powa
RUN set -eux; \
    export DOCKER_BUILD="$DOCKER_BUILD"; \
    export DOCKER_TYPE="$(cat /etc/os-release | grep -E '^ID=' | cut -f2 -d '=')"; \
    if [ $DOCKER_TYPE != "alpine" ]; then \
        export DEBIAN_FRONTEND=noninteractive; \
        export savedAptMark="$(apt-mark showmanual)"; \
    fi; \
    chmod +x /usr/local/bin/*.sh; \
    test "$DOCKER_BUILD" = "build" && "docker_add_group_and_user_$DOCKER_TYPE.sh"; \
    "docker_${DOCKER_BUILD}_$DOCKER_TYPE.sh"; \
    "docker_$DOCKER_BUILD.sh"; \
    "docker_clean_$DOCKER_TYPE.sh"; \
    rm -rf "$HOME" /usr/share/doc /usr/share/man /usr/local/share/doc /usr/local/share/man; \
    rm -rf "/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages/pgadmin4/docs"; \
    find /usr -type f -name "*.la" -delete; \
    find /usr -type f -name "*.pyc" -delete; \
    mkdir -p "$HOME"; \
    chown -R "$USER":"$GROUP" "$HOME"; \
    ln -s powa.wsgi "/usr/local/lib/python$DOCKER_PYTHON_VERSION/site-packages/powa/wsgi.py"; \
    echo done
