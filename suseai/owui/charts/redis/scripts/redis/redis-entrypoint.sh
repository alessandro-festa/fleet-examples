#!/bin/bash
#
# Entrypoint for Redis container images

# Strict mode
set -euo pipefail

# Load functions used by the script
# shellcheck disable=SC1091
. /mnt/redis/scripts/functions.sh
# shellcheck disable=SC1091
. /mnt/redis/scripts/redis-functions.sh

log "Starting Redis"
redis_conf | exec redis-server "$@" -
