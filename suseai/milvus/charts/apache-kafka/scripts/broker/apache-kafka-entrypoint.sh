#!/bin/bash
#
# Entrypoint for Apache Kafka broker pods

# Strict mode
set -euo pipefail

# Load functions used by the script
# shellcheck disable=SC1091
. /mnt/kafka/scripts/functions.sh
# shellcheck disable=SC1091
. /mnt/kafka/scripts/apache-kafka-functions.sh

# TODO: set `KAFKA_NODE_ID` via .Values.xxxx.env
# Previous attemps resulted in node misconfigurations
replica_id=${_KAFKA_POD_HOSTNAME##*-}
broker_id=$((replica_id + _KAFKA_MIN_BROKER_ID))
export "KAFKA_NODE_ID=$broker_id"

# We need to generate the properties file used needed for the healthcheck
# This is needed specially when TLS/Auth is enabled
envvar_preffix="_KAFKA_HEALTHCHECK_"
for envvar in $(printenv | cut -d '=' -f1 | grep "$envvar_preffix"); do
    kafka_conf_set "$_KAFKA__HEALTHCHECK_PROPERTIES_FILE" \
        "$envvar" "$envvar_preffix"
done

log "Starting Apache Kafka broker server"
exec /etc/kafka/docker/run
