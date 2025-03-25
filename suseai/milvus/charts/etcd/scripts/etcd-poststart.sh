#!/bin/bash
#
# @brief Post-start hooks for etcd container images
# @description This script describes a series of actions that will be executed
#   after the etcd containers are started, i.e. authentication and clustering,
#   both of which require to have an already running etcd cluster before they
#   can be configured.

# Strict mode
set -euo pipefail

# Load functions used by the script
# shellcheck disable=SC1091
. /mnt/etcd/scripts/functions.sh
# shellcheck disable=SC1091
. /mnt/etcd/scripts/etcd-functions.sh

INITIAL_CLUSTER="${ETCD_INITIAL_CLUSTER:-}"
readarray -t EXPECTED_MEMBERS <<<"$(get_cluster_peers "$INITIAL_CLUSTER")"
CLUSTER_SIZE="${#EXPECTED_MEMBERS[@]}"
read -r -a PEER_URLS < <(tr ',;' ' ' <<<"$ETCD_INITIAL_ADVERTISE_PEER_URLS")
PEER_URL="${PEER_URLS[0]}"
read -r -a CLIENT_URLS < <(tr ',;' ' ' <<<"$ETCD_ADVERTISE_CLIENT_URLS")
CLIENT_URL="${CLIENT_URLS[0]}"

# Waits until the node is running and the cluster is in a healthy state
while ! HEALTHCHECK_RESULT="$(endpoint_health "$CLIENT_URL")"; do
    debug "The member is not yet healthy:"$'\n'"$HEALTHCHECK_RESULT"
    sleep 1
done

# Enable RBAC if configured
if [[ -n ${ETCDCTL_PASSWORD:-} ]]; then
    export ETCDCTL_USER="${ETCDCTL_USER:-"root"}"
    CONFIGURE_RBAC=false
    if [[ $CLUSTER_SIZE -gt 1 ]]; then
        # Only configure RBAC for new clusters
        if [[ $ETCD_INITIAL_CLUSTER_STATE == "new" ]]; then
            # Enable RBAC in the first member of the cluster to ensure it is
            # only enabled once, to avoid potential concurrency issues
            if [[ ${EXPECTED_MEMBERS[0]} == "$PEER_URL" ]]; then
                CONFIGURE_RBAC=true
            fi
        fi
    else
        # Always configure RBAC in single-node when there is no data
        CONFIGURE_RBAC=true
    fi
    # Proceed to enable RBAC if required
    if [[ $CONFIGURE_RBAC == "true" ]]; then
        # Only configure if it is not already enabled
        if [[ "$(etcdctl auth status 2>/dev/null)" != *"Status: true"* ]]; then
            log "Enabling authentication for $ETCDCTL_USER user"
            etcdctl user add "$ETCDCTL_USER:$ETCDCTL_PASSWORD"
            etcdctl user grant-role "$ETCDCTL_USER" root
            etcdctl auth enable
        fi
    fi
fi

# Update clustering configuration after a cluster has been created
# This is usually required after a cluster resize when nodes are added/removed
# Note: This also applies for single-node scenarios after a resize
if [[ $CLUSTER_SIZE -gt 1 && $ETCD_INITIAL_CLUSTER_STATE != "new" ]]; then
    if CURRENT_MEMBERS_STRING="$(get_current_cluster_peers)"; then
        read -r -a CURRENT_MEMBERS <<<"$CURRENT_MEMBERS_STRING"
        # Remove extraneous members from cluster that should not be part of it
        # This usually happens when resizing clusters and nodes are deleted
        for MEMBER in "${CURRENT_MEMBERS[@]}"; do
            if [[ " ${EXPECTED_MEMBERS[*]} " != *" ${MEMBER} "* ]]; then
                if MEMBER_ID="$(get_member_id "$MEMBER")"; then
                    log "Removing member from cluster: $MEMBER_ID ($MEMBER)"
                    # Leave removal for the next node (or next restart)
                    if ! etcdctl member remove "$MEMBER_ID"; then
                        debug "Could not remove member: $MEMBER_ID ($MEMBER)"
                    fi
                fi
            fi
        done
    fi
fi
