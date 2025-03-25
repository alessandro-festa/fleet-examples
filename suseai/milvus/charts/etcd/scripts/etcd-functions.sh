#!/bin/bash
#
# Common functions for etcd

# @description Check the health of a specific etcd endpoint.
#
# @arg $1 string The client endpoint URL to check.
#
# @stdout The results of the 'etcdctl endpoint health' command.
#
# @exitcode 0 If successful.
# @exitcode 1 If the 'etcdctl ednpoint health' command failed.
endpoint_health() {
    local endpoint="$1"
    ETCDCTL_ENDPOINTS="$endpoint" etcdctl endpoint health 2>&1
}

# @description Obtain the list of peer URLs for all cluster members using the
#   provided list of initial cluster members.
#
# @stdout Space-separated list of cluster member peer URLs.
get_cluster_peers() {
    local -a initial_cluster
    read -r -a initial_cluster < <(tr ',;' ' ' <<<"${*:-}")
    if [[ ${#initial_cluster[@]} -eq 0 ]]; then
        return
    fi
    # The initial cluster input string has the following format:
    # node-0=peerurl-0[,node-1=peerurl-1[,...]]
    # We only want to obtain the peer addresses, so we remove the 1st part
    for member in "${initial_cluster[@]}"; do
        echo "${member#*=}"
    done | sort
}

# @description Print the output of the 'etcdctl member list' command.
#   Retry up to 10 times in case of an error.
#
# @stdout The results of the 'etcdctl member list' command in case of success.
#
# @exitcode 0 If successful.
# @exitcode 1 An error occurred obtaining the member list.
get_current_cluster_members() {
    # Obtain the result of the 'etcdctl member list' command
    local member_list=""
    local max_attempts=10
    local attempt
    for ((attempt = 0; attempt < max_attempts; attempt++)); do
        if member_list="$(etcdctl member list 2>/dev/null || true)"; then
            break
        else
            debug "Failed to obtain member list"
        fi
    done
    if [[ -n $member_list ]]; then
        echo "$member_list"
    else
        return 1
    fi
}

# @description Obtain the list of etcd peers from the 'etcdctl member list'
#   command.
#
# @stdout Space-separated list of etcd peer URLs of current cluster members.
#
# @exitcode 0 If successful.
# @exitcode 1 An error occurred obtaining the cluster peer list.
get_current_cluster_peers() {
    local cluster_members
    if ! cluster_members="$(get_current_cluster_members)"; then
        log "Failed to obtain the list of members in the cluster"
        return 1
    fi
    # Loop through the results of 'etcd member list' and obtain all peers
    local -a peer_addresses=()
    local member member_peer_url
    # Array format: ID, Status, Name, Peer Addrs, Client Addrs, Is Learner
    while read -r -a member; do
        # Skip empty lines
        [[ -z ${member[*]} ]] && continue
        # Skip malformated lines
        [[ ${#member[@]} -lt 6 ]] && continue
        # Obtain the peer (4th element in the array)
        member_peer_url="${member[3]//,/}"
        peer_addresses+=("$member_peer_url")
    done <<<"$cluster_members"
    # Print the list of peer addresses if successful, throw an error otherwise
    if [[ ${#peer_addresses[@]} -gt 0 ]]; then
        echo "${peer_addresses[@]}"
    else
        log "Could not obtain peer addresses in the cluster"
        return 1
    fi
}

# @description Check if the cluster is in a healthy state.
#
# @exitcode 0 If the cluster is healthy.
# @exitcode 1 The cluster is not healthy (i.e. unhealthy).
cluster_healthy() {
    local num_members=0
    local healthy_members=0
    local cluster_peers
    if cluster_peers="$(get_current_cluster_peers)"; then
        local -a cluster_peers_array
        read -r -a cluster_peers_array <<<"$cluster_peers"
        num_members="${#cluster_peers_array[@]}"
        for cluster_peer in "${cluster_peers_array[@]}"; do
            if endpoint_health "$cluster_peer"; then
                ((healthy_members++))
            fi
        done
    else
        return 1
    fi
    ((healthy_members >= num_members / 2 + 1))
}

# @description Get the etcd member ID hexadecimal value from a peer URL.
#
# @arg $1 string Peer URL for which to obtain the member ID value.
#
# @stdout The member ID.
#
# @exitcode 0 If successful.
# @exitcode 1 An error occurred obtaining the cluster member ID.
get_member_id() {
    local peer_url="$1"
    local cluster_members
    if ! cluster_members="$(get_current_cluster_members)"; then
        log "Failed to obtain the list of members in the cluster"
        return 1
    fi
    # Loop through the results of 'etcd member list' and obtain the member ID
    local member_id=""
    local member member_peer_url
    # Array format: ID, Status, Name, Peer Addrs, Client Addrs, Is Learner
    while read -r -a member; do
        # Skip empty lines
        [[ -z ${member[*]} ]] && continue
        # Retry the main loop again in case of a malformated line
        [[ ${#member[@]} -lt 6 ]] && continue
        # Obtain the peer (4th element in the array)
        member_peer_url="${member[3]//,/}"
        # Check if it matches the peer URL we are looking for
        if [[ $member_peer_url == "$peer_url" ]]; then
            member_id="${member[0]//,/}"
        fi
    done <<<"$cluster_members"
    # Print the member ID if successful, throw an error otherwise
    if [[ -n $member_id ]]; then
        debug "Obtained member ID for peer $peer_url: $member_id"
        echo "$member_id"
    else
        log "Could not obtain member id for $peer_url, is it in the cluster?"
        return 1
    fi
}
