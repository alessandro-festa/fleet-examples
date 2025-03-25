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

DATA_DIR="/mnt/etcd/data"
INITIAL_CLUSTER="${ETCD_INITIAL_CLUSTER:-}"
readarray -t EXPECTED_MEMBERS <<<"$(get_cluster_peers "$INITIAL_CLUSTER")"
CLUSTER_SIZE="${#EXPECTED_MEMBERS[@]}"
read -r -a PEER_URLS < <(tr ',;' ' ' <<<"$ETCD_INITIAL_ADVERTISE_PEER_URLS")
PEER_URL="${PEER_URLS[0]}"

# Wait for headless service to resolve to all expected nodes in the cluster
if [[ $CLUSTER_SIZE -gt 1 ]] && is_kubernetes; then
    CLUSTER_HOSTNAME="${PEER_URL//*"://$ETCD_NAME."/}"
    CLUSTER_HOSTNAME="${CLUSTER_HOSTNAME//":"*/}"
    log "Waiting for headless service DNS resolution to succeed"
    wait_for_hostname_resolution "$CLUSTER_HOSTNAME" "$CLUSTER_SIZE"
fi

# If not a new cluster, check if the node needs to be added to the cluster
# This can only happen if the cluster is already in a healthy state
if [[ $CLUSTER_SIZE -gt 1 && $ETCD_INITIAL_CLUSTER_STATE != "new" ]]; then
    if cluster_healthy; then
        # Check if the current peer is already registered in the cluster
        if PEERS="$(get_current_cluster_peers)"; then
            # If the peer is not listed in the cluster, proceed to add it
            if [[ " $PEERS " != *" $PEER_URL "* ]]; then
                log "Joining existing etcd cluster"
                # If the data directory is not empty, the member will not be
                # able to join the cluster, so we must delete it beforehand
                if ! is_dir_empty "$DATA_DIR"; then
                    log "The data directory is not empty, it will be removed"
                    rm -rf "${DATA_DIR:?}"/*
                fi
                etcdctl member add "$ETCD_NAME" --peer-urls="$PEER_URL"
            fi
        fi
    else
        # If this is indeed a new member, the server would eventually fail and
        # the entrypoint would be re-executed after a pod restart, hopefully
        # with a healthy cluster state
        log "Cluster not in healthy state, new members cannot be added for now"
    fi
fi

# TODO: Add support for startup from snapshot (i.e. without mounted data)
# TODO: Add support for disaster recovery (i.e. with mounted data)
log "Starting etcd"
exec etcd "$@"
