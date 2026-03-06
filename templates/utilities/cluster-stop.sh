#!/bin/bash
# Utility: Stop Cluster
# Stops all running vLLM containers
source "$(dirname "$0")/../_common.sh"
check_connection
echo "Stopping vLLM cluster on ${SPARK_HOST}..."
run_on_spark "./launch-cluster.sh stop"
echo "Cluster stopped."
