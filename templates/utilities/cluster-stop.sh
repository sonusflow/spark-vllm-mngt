#!/bin/bash
# spark-vllm-mngt — github.com/sonusflow/spark-vllm-mngt
# Copyright (c) 2026 sonusflow. MIT License.
# Utility: Stop Cluster
# Stops all running vLLM containers
source "$(dirname "$0")/../_common.sh"
check_connection
echo "Stopping vLLM cluster on ${SPARK_HOST}..."
run_on_spark "./launch-cluster.sh stop"
echo "Cluster stopped."
