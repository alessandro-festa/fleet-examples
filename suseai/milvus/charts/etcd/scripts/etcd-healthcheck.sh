#!/bin/bash
#
# Entrypoint for etcd container images

# Strict mode
set -euo pipefail

# Load functions used by the script
# shellcheck disable=SC1091
. /mnt/etcd/scripts/functions.sh
# shellcheck disable=SC1091
. /mnt/etcd/scripts/etcd-functions.sh

# Obtain etcd endpoint from ETCD_NAME
read -r -a CLIENT_URLS < <(tr ',;' ' ' <<<"$ETCD_ADVERTISE_CLIENT_URLS")
if [[ ${#CLIENT_URLS[@]} -lt 1 ]]; then
    log "Could not obtain any etcd endpoint from ETCD_ADVERTISE_CLIENT_URLS"
    exit 1
fi
if ! ENDPOINT_HEALTH_RESULT="$(endpoint_health "${CLIENT_URLS[0]}")"; then
    log "Unhealthy endpoint"
    debug "$ENDPOINT_HEALTH_RESULT"
    exit 1
fi
