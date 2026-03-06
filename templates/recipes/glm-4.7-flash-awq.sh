#!/bin/bash
# spark-vllm-mngt — github.com/sonusflow/spark-vllm-mngtn# Copyright (c) 2026 sonusflow. MIT License.
# Recipe: GLM-4.7 Flash AWQ (Solo)
# Model: Salyut1/GLM-4.7-Flash-AWQ
# Category: Recipes — LLM
source "$(dirname "$0")/../_common.sh"
check_connection
echo "Starting GLM-4.7 Flash AWQ on ${SPARK_HOST}..."
run_on_spark "./run-recipe.sh glm-4.7-flash-awq --solo -d"
