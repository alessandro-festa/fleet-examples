#!/bin/bash
#
# Common functions for Apache Kafka

# @description Set a configuration in Apache Kafka's configuration file.
#
# @arg $1 string Full path for properties file where the config must be set.
# @arg $2 string The environment variable containing the value to set.
# @arg $3 string (optional) Prefix to be removed from $2 to use it as key.
kafka_conf_set() {
    local properties_file="$1"
    local envvar_name="$2"
    local envvar_prefix="${3:-}"
    local entry_name=""
    local entry_value=""
    local entry=""

    entry_name=$(echo "${envvar_name##"$envvar_prefix"}" \
        | tr '[:upper:]' '[:lower:]' | tr '_' '.')
    entry_value=$(printenv "$envvar_name")
    entry="$entry_name=$entry_value"

    log "Setting $entry_name in $properties_file"
    if grep -q "$entry_name" "$properties_file"; then
        sed 's/'"$entry_name"'=.*/'"$entry_name"'='"$entry_value"'/'
    else
        echo "$entry">>"$properties_file"
    fi
}
