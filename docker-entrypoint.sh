#!/bin/sh
# -*- coding: utf-8 -*-

# build sync directory path
SYNC_DIR_PATH="${GIT_SYNC_ROOT:-/tmp}/${GIT_SYNC_DEST}/config"

# ensure directories exist
mkdir -p "${SYNC_DIR_PATH}" /config

# connect sync directory after initial one-time sync
if [ "${GIT_SYNC_ONE_TIME}" = 'true' ]; then
    echo "==> Running initial sync for connection"
    if /sbin/git-sync --one-time; then
        echo "==> Connected: ${SYNC_DIR_PATH} -> /config"
        ln -sf "${SYNC_DIR_PATH}"/* /config
    else
        echo "==> Error: Failed to connect configuration due to failed git-sync command!"
        exit 1
    fi
fi

# exec container command
if [ "${GIT_SYNC_ONE_TIME}" != 'true' ]; then
    echo "==> Continue execution"
    exec "$@"
fi

