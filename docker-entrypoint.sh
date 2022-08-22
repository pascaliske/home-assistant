#!/bin/sh
# -*- coding: utf-8 -*-

# build sync directory path
SYNC_DIR_PATH="${GIT_SYNC_ROOT:-/tmp}/${GIT_SYNC_DEST}/config"

# ensure directories exist
mkdir -p "${SYNC_DIR_PATH}" /config

# one-time sync required for initial connection
/sbin/git-sync --one-time

# connect sync directory
ln -sf "${SYNC_DIR_PATH}"/* /config

# exec container command
if [ "${GIT_SYNC_ONE_TIME}" != 'true' ]; then
    exec "$@"
fi

