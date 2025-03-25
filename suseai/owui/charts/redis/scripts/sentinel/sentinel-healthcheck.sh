#!/bin/bash
#
# Health check script for Sentinel containers

# Strict mode
set -euo pipefail

# Load functions used by the script
# shellcheck disable=SC1091
. /mnt/sentinel/scripts/functions.sh
# shellcheck disable=SC1091
. /mnt/sentinel/scripts/sentinel-functions.sh

if PING_RESPONSE="$(sentinel_cli_exec ping)"; then
    if [[ $PING_RESPONSE != PONG ]]; then
        log "Invalid response"
        echo "$PING_RESPONSE"
        exit 1
    fi
else
    log "Could not perform ping"
    exit 1
fi
