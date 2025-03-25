#!/bin/bash
#
# Common functions for Redis

# @description Print Redis configuration used to start the server.
#
# @stdout Redis configuration.
redis_conf() {
    if [[ -n ${_REDIS_PASSWORD:-} ]]; then
        # Authentication to the node
        printf 'requirepass "%s"\n' "${_REDIS_PASSWORD//\"/\\\"}"
        printf 'masterauth "%s"\n' "${_REDIS_PASSWORD//\"/\\\"}"
    fi
    # Replication configuration
    # Should not be enabled for Redis Cluster mode (_REDIS_MASTER_HOST unset)
    local host="$HOSTNAME.$_FQDN_CLUSTER_PREFIX"
    local master_host="${_REDIS_MASTER_HOST:-}"
    # Resolve the hostnames beforehand, to avoid problems during the setup
    local resolved_host resolved_master_host
    resolved_host="$(wait_for_hostname_resolution "$host")"
    if [[ -n $master_host && $master_host != "$host" ]]; then
        resolved_master_host="$(wait_for_hostname_resolution "$master_host")"
        if [[ ${_USE_HOSTNAMES:-false} == true ]]; then
            echo "replicaof $_REDIS_MASTER_HOST $_REDIS_PORT"
            echo "replica-announce-ip $host"
        else
            echo "replicaof $resolved_master_host $_REDIS_PORT"
            echo "replica-announce-ip $resolved_host"
        fi
        echo "replica-announce-port $_REDIS_PORT"
    fi
    # Redis Cluster configuration
    if [[ -n ${_REDIS_CLUSTER_NODES:-} ]]; then
        echo "cluster-announce-ip $(wait_for_hostname_resolution "$HOSTNAME")"
        echo "cluster-announce-hostname $HOSTNAME.$_FQDN_CLUSTER_PREFIX"
        echo "cluster-announce-human-nodename $HOSTNAME"
    fi
    if [[ -e ${_REDIS_CONF_FILE} ]]; then
        cat "$_REDIS_CONF_FILE"
    fi
}

# @description Get the value of a Redis configuration entry.
#
# @arg $1 The configuration entry name.
#
# @stdout Value of the configuration entry.
redis_conf_get() {
    local -r entry_name="$1"
    local last_entry=""
    local found=false
    while read -r line; do
        if [[ $line == "$entry_name "* ]]; then
            last_entry="${line##"$entry_name "}"
            found=true
        fi
    done < <(redis_conf)
    if "$found"; then
        # Only print the string if it is not empty
        if [[ -n $last_entry ]]; then
            # If the string is quoted, remove the quotes
            if [[ $last_entry =~ ^\"([^\"]*)\"$ ]]; then
                echo "${BASH_REMATCH[1]}"
            elif [[ $last_entry =~ ^\'([^\']*)\'$ ]]; then
                echo "${BASH_REMATCH[1]}"
            else
                echo "$last_entry"
            fi
        fi
    else
        return 1
    fi
}

# @description Execute a Redis command using the redis-cli CLI tool.
#
# @stdout Output of the Redis CLI tool.
redis_cli_exec() {
    redis_cli_args=(redis-cli -h localhost)
    # Check if TLS is enabled
    if ! redis_conf_get tls-port >/dev/null; then
        redis_cli_args+=(-p "$(redis_conf_get port)")
    else
        redis_cli_args+=(
            --tls -p "$(redis_conf_get tls-port)"
            --cacert "$(redis_conf_get tls-ca-cert-file)"
        )
        if [[ "$(redis_conf_get tls-auth-clients || true)" == yes ]]; then
            redis_cli_args+=(
                --cert "$(redis_conf_get tls-cert-file)"
                --key "$(redis_conf_get tls-key-file)"
            )
        fi
    fi
    "${redis_cli_args[@]}" "$@"
}
