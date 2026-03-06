#!/bin/bash
# spark-vllm-mngt — github.com/sonusflow/spark-vllm-mngt
# Copyright (c) 2026 sonusflow. MIT License.
# Utility: Build vLLM Docker Image
# Builds the vllm-node Docker image on the DGX Spark
source "$(dirname "$0")/../_common.sh"
check_connection
echo "Building vLLM Docker image on ${SPARK_HOST}..."
echo "This may take 30-60 minutes on first build."
run_on_spark "./build-and-copy.sh"
