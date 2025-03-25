#!/bin/bash
#
# Readiness check script for Apache Kafka controller nodes

# Strict mode
set -euo pipefail

exec kafka-metadata-quorum.sh \
    --bootstrap-controller="$HOSTNAME:9093" \
    --command-config="$_KAFKA__HEALTHCHECK_PROPERTIES_FILE" \
    describe --status
