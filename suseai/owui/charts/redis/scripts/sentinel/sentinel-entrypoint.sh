#!/bin/bash
#
# Entrypoint for Redis container images

# Strict mode
set -euo pipefail

# Load functions used by the script
# shellcheck disable=SC1091
. /mnt/sentinel/scripts/functions.sh
# shellcheck disable=SC1091
. /mnt/sentinel/scripts/sentinel-functions.sh

if [[ ! -e $_SENTINEL_CONF_FILE ]]; then
    log "Generating Sentinel configuration file"
    sentinel_conf_defaults >"$_SENTINEL_CONF_FILE"
else
    log "Detected an existing Sentinel configuration file"
fi

log "Starting Redis Sentinel"
exec redis-sentinel "$_SENTINEL_CONF_FILE" "$@"
