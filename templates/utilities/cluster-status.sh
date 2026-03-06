#!/bin/bash
# spark-vllm-mngt — github.com/sonusflow/spark-vllm-mngt
# Copyright (c) 2026 sonusflow. MIT License.
# Utility: Cluster Status
# Shows running vLLM containers and Ray cluster status
source "$(dirname "$0")/../_common.sh"
check_connection
echo "=== vLLM Cluster Status on ${SPARK_HOST} ==="
run_on_spark "./launch-cluster.sh status"
