#!/bin/bash
#
# Entrypoint for Redis container images in Redis Cluster mode

# Strict mode
set -euo pipefail

# Load functions used by the script
# shellcheck disable=SC1091
. /mnt/redis/scripts/functions.sh
# shellcheck disable=SC1091
. /mnt/redis/scripts/redis-functions.sh

read -r -a CLUSTER_NODES < <(tr ',;' ' ' <<<"$_REDIS_CLUSTER_NODES")
if [[ ${#CLUSTER_NODES[@]} -eq 0 ]]; then
    log "Could not obtain the list of Redis Cluster nodes"
    exit 1
fi
FIRST_NODE="${CLUSTER_NODES[0]}"
for NODE in "${CLUSTER_NODES[@]}"; do
    [[ $NODE == "$HOSTNAME."* ]] && CURRENT_NODE="$NODE" && break
done
if [[ -z ${CURRENT_NODE:-} ]]; then
    log "Could not obtain the hostname for this node"
    exit 1
fi
REPLICAS_PER_MASTER="$_REDIS_CLUSTER_REPLICAS_PER_MASTER"

# Helper functions
redis_cluster_configuration_required() {
    # First node will perform initial configuration only if not configured
    # In this case, the Redis Cluster config file nodes.conf doesn't exist or
    # has less than 3 entries
    if [[ $FIRST_NODE == "$HOSTNAME."* ]]; then
        if [[ ! -e $_REDIS_CLUSTER_CONF_FILE ||
            "$(wc -l <"$_REDIS_CLUSTER_CONF_FILE")" -lt 3 ]]; then
            return
        fi
    fi
    # Check if there are any nodes to be added, and proceed to add them
    # If it is the case, proceed to do it in the last added node to the cluster
    # This way, they are added faster than if it was to be done by the 1st node
    # since we would not need to wait for all nodes to get restarted but only 1
    if [[ -e $_REDIS_CLUSTER_CONF_FILE &&
        "$(wc -l <"$_REDIS_CLUSTER_CONF_FILE")" -ge 3 ]]; then
        REDIS_CLUSTER_CONF="$(<"$_REDIS_CLUSTER_CONF_FILE")"
        NODES_TO_ADD=false
        for NODE in "${CLUSTER_NODES[@]}"; do
            if [[ $REDIS_CLUSTER_CONF != *"${NODE%:*}"* ]]; then
                NODES_TO_ADD=true # there are nodes not in the cluster
            else
                LAST_NODE="$NODE" # last node in cluster
            fi
        done
        "$NODES_TO_ADD" && [[ $CURRENT_NODE == "$LAST_NODE" ]] && return
    fi
    false
}

# Update the IP addresses in the Redis Cluster configuration file - nodes.conf
# This may be required since Kubernetes updates IP addresses after each deploy
if [[ ${_REDIS_CLUSTER_UPDATE_IP_ADDRESSES:-yes} == yes &&
    -e $_REDIS_CLUSTER_CONF_FILE &&
    "$(wc -l <"$_REDIS_CLUSTER_CONF_FILE")" -ge 3 ]]; then
    # Read the configuration file line-by-line and update the IP addresses
    # This could be simplified with sed/grep, but we prefer not bundling them
    REDIS_CLUSTER_UPDATED_CONF=""
    while read -r LINE; do
        if [[ -n $REDIS_CLUSTER_UPDATED_CONF ]]; then
            REDIS_CLUSTER_UPDATED_CONF+=$'\n'
        fi
        # Format: <id> <ip>:0@<port>,<hostname>,...
        if [[ $LINE =~ ^([^ ]+ )([^:]+)(:[^,]+,)([^,]+)(,.*) ]]; then
            # Resolve the IP address of the node and update it in the config
            NODE_HOSTNAME="${BASH_REMATCH[4]}"
            NODE_IP_ADDRESS="$(wait_for_hostname_resolution "$NODE_HOSTNAME")"
            REDIS_CLUSTER_UPDATED_CONF+="${BASH_REMATCH[1]}$NODE_IP_ADDRESS\
${BASH_REMATCH[3]}$NODE_HOSTNAME${BASH_REMATCH[5]}"
            # Inform users in case there was any change
            NODE_PREVIOUS_IP_ADDRESS="${BASH_REMATCH[2]}"
            if [[ $NODE_IP_ADDRESS != "$NODE_PREVIOUS_IP_ADDRESS" ]]; then
                log "Updating IP address for node $NODE_HOSTNAME \
from $NODE_PREVIOUS_IP_ADDRESS to $NODE_IP_ADDRESS"
            fi
        else
            # Not all lines follow the format, but those are not relevant here
            REDIS_CLUSTER_UPDATED_CONF+="$LINE"
        fi
    done <"$_REDIS_CLUSTER_CONF_FILE"
    # Write the changes to the configuration file
    echo "$REDIS_CLUSTER_UPDATED_CONF" >"$_REDIS_CLUSTER_CONF_FILE"
fi

if ! redis_cluster_configuration_required; then
    # For all nodes in the cluster except the 1st, always start Redis and exit
    exec /mnt/redis/scripts/redis-entrypoint.sh # This will exit the script
fi

# For the 1st node, start the Redis in the background to initialize cluster
/mnt/redis/scripts/redis-entrypoint.sh &

# Ideally we would use a postStart lifecycle hook for this part, but we are
# skipping it for several reasons:
# - It is very hard to troubleshoot PostStart hook errors because its logs are
#   not printed anywhere
# - Related, Container logs cannot be retrieved until the PostStart hook
#   succeeds, because it is stuck at ContainerCreating
# - Deleting the pods may take a lot of time if the container gets stuck at
#   ContainerCreating

# Waits until all nodes in the cluster are running
while true; do
    CLUSTER_NODES_READY=true
    for CLUSTER_NODE in "${CLUSTER_NODES[@]}"; do
        NODE_HOST="${CLUSTER_NODE%:*}"
        if ! RESPONSE="$(redis_cli_exec -h "$NODE_HOST" ping 2>/dev/null)" ||
            [[ $RESPONSE != PONG ]]; then
            debug "Node $CLUSTER_NODE is not yet ready:"$'\n'"$RESPONSE"
            CLUSTER_NODES_READY=false
        fi
    done
    "$CLUSTER_NODES_READY" && break
    sleep 1
done

# Initialize the cluster, or add missing nodes to it
if [[ "$(wc -l <"$_REDIS_CLUSTER_CONF_FILE")" -lt 3 ]]; then
    # If it has not been initialized yet, the config file has less than 3 lines
    log "Initializing the cluster for the first time"
    redis_cli_exec --cluster create "${CLUSTER_NODES[@]}" \
        --cluster-replicas "$REPLICAS_PER_MASTER" <<<"yes"
else
    # This block will only be executed in the scenario where there are missing
    # nodes to be added to the cluster
    REDIS_CLUSTER_CONF="$(<"$_REDIS_CLUSTER_CONF_FILE")"
    # Count the number of known nodes there are currently in the cluster
    CURRENT_MASTERS=0
    while read -r LINE; do
        if [[ $LINE =~ ([ ,]master ) ]]; then
            ((++CURRENT_MASTERS))
        fi
    done <<<"$REDIS_CLUSTER_CONF"
    # Count how many masters need to be added
    EXPECTED_MASTERS="$((${#CLUSTER_NODES[@]} / (1 + REPLICAS_PER_MASTER)))"
    MASTERS_TO_ADD="$((EXPECTED_MASTERS - CURRENT_MASTERS))"
    # Find nodes not already in the cluster, and add them
    for ((i = 0; i < ${#CLUSTER_NODES[@]}; i++)); do
        NODE="${CLUSTER_NODES[i]}"
        if [[ $REDIS_CLUSTER_CONF != *"${NODE%:*}"* ]]; then
            # Check if node should be added as a master
            if ((MASTERS_TO_ADD-- > 0)); then
                log "Adding master node to the cluster: $NODE"
                redis_cli_exec --cluster add-node "$NODE" "$CURRENT_NODE"
            else
                log "Adding replica node to the cluster: $NODE"
                redis_cli_exec --cluster add-node "$NODE" "$CURRENT_NODE" \
                    --cluster-slave
            fi
        fi
    done
    # Wait for all nodes to be recognized by another node in the cluster
    # In this case, we choose the first node
    MAX_ATTEMPTS="30"
    WAIT_TIME="1"
    for ((ATTEMPT = 0; ATTEMPT < MAX_ATTEMPTS; ATTEMPT++)); do
        sleep "$WAIT_TIME"
        KNOWN_NODES="$(redis_cli_exec -h "${FIRST_NODE%:*}" cluster nodes)"
        for NODE in "${CLUSTER_NODES[@]}"; do
            if [[ $KNOWN_NODES != *"${NODE%:*}"* ]]; then
                debug "The cluster status was not synchronized yet, retrying"
                break
            fi
        done
    done
    # Rebalance the shards in the cluster in order to populate the new masters
    log "Rebalancing the shards in the cluster"
    redis_cli_exec --cluster rebalance "$CURRENT_NODE" \
        --cluster-use-empty-masters
fi

# Resume execution of Redis
wait
