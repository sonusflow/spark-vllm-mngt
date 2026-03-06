#!/bin/bash
# spark-vllm-mngt — github.com/sonusflow/spark-vllm-mngt
# Copyright (c) 2026 sonusflow. MIT License.
# Utility: Cluster Logs
# Shows last 50 lines of the vLLM container logs
source "$(dirname "$0")/../_common.sh"
check_connection
echo "=== vLLM Container Logs (last 50 lines) ==="
run_remote "docker logs --tail 50 vllm_node 2>&1"
