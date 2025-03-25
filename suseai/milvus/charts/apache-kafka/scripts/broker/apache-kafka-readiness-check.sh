#!/bin/bash
#
# Readiness check script for Apache Kafka broker nodes

# Strict mode
set -euo pipefail

exec kafka-broker-api-versions.sh \
    --bootstrap-server="$HOSTNAME:9092" \
    --command-config="$_KAFKA__HEALTHCHECK_PROPERTIES_FILE"
