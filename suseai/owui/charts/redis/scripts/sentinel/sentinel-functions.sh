#!/bin/bash
#
# Common functions for Sentinel

# @description Print default configuration used to start the Sentinel server.
#
# @stdout Sentinel default configuration.
sentinel_conf_defaults() {
    # Resolve the hostnames beforehand, to avoid problems during the setup
    local host="$HOSTNAME.$_FQDN_CLUSTER_PREFIX"
    local master_host="$_REDIS_MASTER_HOST"
    local resolved_host resolved_master_host
    resolved_host="$(wait_for_hostname_resolution "$host")"
    resolved_master_host="$(wait_for_hostname_resolution "$master_host")"
    # Sentinel configurations for the main master
    if [[ ${_USE_HOSTNAMES:-false} == true ]]; then
        echo "sentinel resolve-hostnames yes"
        echo "sentinel announce-hostnames yes"
        echo "sentinel announce-ip $host"
        printf 'sentinel monitor %s %s %s %s\n' "$_SENTINEL_MASTER_SET" \
            "$master_host" "$_REDIS_PORT" "$_SENTINEL_QUORUM"
    else
        echo "sentinel announce-ip $resolved_host"
        printf 'sentinel monitor %s %s %s %s\n' "$_SENTINEL_MASTER_SET" \
            "$resolved_master_host" "$_REDIS_PORT" "$_SENTINEL_QUORUM"
    fi
    echo "sentinel announce-port $_SENTINEL_PORT"
    if [[ -n ${_SENTINEL_DOWN_AFTER_MS:-} ]]; then
        printf 'sentinel down-after-milliseconds %s %s\n' \
            "$_SENTINEL_MASTER_SET" "$_SENTINEL_DOWN_AFTER_MS"
    fi
    if [[ -n ${_SENTINEL_FAILOVER_TIMEOUT:-} ]]; then
        printf 'sentinel failover-timeout %s %s\n' \
            "$_SENTINEL_MASTER_SET" "$_SENTINEL_FAILOVER_TIMEOUT"
    fi
    if [[ -n ${_SENTINEL_PARALLEL_SYNCS:-} ]]; then
        printf 'sentinel parallel-syncs %s %s\n' \
            "$_SENTINEL_MASTER_SET" "$_SENTINEL_PARALLEL_SYNCS"
    fi
    # Authentication
    if [[ -n ${_REDIS_PASSWORD:-} ]]; then
        printf 'sentinel auth-pass %s "%s"\n' \
            "$_SENTINEL_MASTER_SET" "${_REDIS_PASSWORD//\"/\\\"}"
    fi
    # Extra configurations
    if [[ -e ${_SENTINEL_DEFAULTS_CONF_FILE} ]]; then
        cat "$_SENTINEL_DEFAULTS_CONF_FILE"
    fi
}

# @description Get the value of a Redis configuration entry.
#
# @arg $1 The configuration entry name.
#
# @stdout Value of the configuration entry.
sentinel_conf_get() {
    local -r entry_name="$1"
    local last_entry=""
    local found=false
    while read -r line; do
        # Find the last matching line
        if [[ $line == "$entry_name "* ]]; then
            last_entry="${line##"$entry_name "}"
            found=true
        fi
    done </mnt/sentinel/data/sentinel.conf
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
sentinel_cli_exec() {
    redis_cli_args=(redis-cli -h localhost)
    # Check if TLS is enabled
    if ! sentinel_conf_get tls-port >/dev/null; then
        redis_cli_args+=(-p "$(sentinel_conf_get port)")
    else
        redis_cli_args+=(
            --tls -p "$(sentinel_conf_get tls-port)"
            --cacert "$(sentinel_conf_get tls-ca-cert-file)"
        )
        if [[ "$(sentinel_conf_get tls-auth-clients || true)" == yes ]]; then
            redis_cli_args+=(
                --cert "$(sentinel_conf_get tls-cert-file)"
                --key "$(sentinel_conf_get tls-key-file)"
            )
        fi
    fi
    "${redis_cli_args[@]}" "$@"
}
