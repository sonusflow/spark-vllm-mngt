#!/bin/bash
# spark-vllm-mngt — github.com/sonusflow/spark-vllm-mngtn# Copyright (c) 2026 sonusflow. MIT License.
# Recipe: MiniMax M2 AWQ
# Model: QuantTrio/MiniMax-M2-AWQ
# Category: Recipes — LLM
source "$(dirname "$0")/../_common.sh"
check_connection
echo "Starting MiniMax M2 AWQ on ${SPARK_HOST}..."
run_on_spark "./run-recipe.sh minimax-m2-awq --solo -d"
