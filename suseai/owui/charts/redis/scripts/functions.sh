#!/bin/bash
#
# Common functions

# Setup default values for debugging modes
DEBUG_MODE="${DEBUG_MODE:-false}"
TRACE_MODE="${TRACE_MODE:-false}"
QUIET_MODE="${QUIET_MODE:-false}"
if [[ $QUIET_MODE != "true" && $TRACE_MODE == "true" ]]; then
    set -x
fi

# @description Print a line to stderr.
#
# @arg $1..$n Log messages to print to stderr.
#
# @stderr The log message.
log() {
    if [[ $QUIET_MODE != "true" ]]; then
        echo >&2 "$@"
    fi
}

# @description Print a line to stderr if DEBUG_MODE or TRACE_MODE are enabled.
#
# @arg $1..$n Log messages to print to stderr.
#
# @stderr The log message, if DEBUG_MODE or TRACE_MODE are enabled.
debug() {
    if [[ $TRACE_MODE == "true" || $DEBUG_MODE == "true" ]]; then
        log "[debug] $*"
    fi
}

# @description Check if a directory is empty.
#
# @arg $1 string Directory to check.
#
# @exitcode 0 The directory is empty.
# @exitcode 1 The directory is not empty.
is_dir_empty() {
    local dir="$1"
    [[ ! -e $dir || -z $(ls -A "$dir") ]]
}

# @description Check if this script is running inside a Kubernetes pod.
#
# @exitcode 0 Running inside a Kubernetes pod.
# @exitcode 1 Not running inside a Kubernetes pod.
is_kubernetes() {
    [[ -e /var/run/secrets/kubernetes.io ]]
}

# @description Resolve a DNS hostname to an IP address.
#
# @arg $1..$n string Hostnames to resolve.
#
# @stdout The results of the DNS hostname resolution.
#
# @exitcode 0 If successful
# @exitcode 1 The attempt to resolve the hostname failed.
resolve_hostname() {
    while read -r -a dns_entry; do
        echo "${dns_entry[0]}"
    done < <(getent ahosts "$@") | sort | uniq
}

# @description Wait for DNS hostname resolution to succeed for up to 2 minutes.
#
# @arg $1 string Hostname to resolve.
# @arg $2 string Amount of expected hostnames (optional).
#
# @exitcode 0 If successful.
# @exitcode 1 All attempts to resolve the hostname failed.
wait_for_hostname_resolution() {
    local hostname="$1"
    local num_members="${2:-1}"
    local max_attempts=120
    local sleep_time=1
    local -a hostname_ips
    local attempt
    for ((attempt = 0; attempt < max_attempts; attempt++)); do
        readarray -t hostname_ips < <(resolve_hostname "$hostname")
        if ((${#hostname_ips[@]} == num_members)); then
            break
        fi
        debug "DNS resolution for $hostname expected $num_members nodes but
found ${#hostname_ips[@]}: ${hostname_ips[*]}"
        sleep "$sleep_time"
    done
    if ((${#hostname_ips[@]} < num_members)); then
        log "Could not resolve hostname $hostname"
        return 1
    fi
    echo "${hostname_ips[@]}"
}
