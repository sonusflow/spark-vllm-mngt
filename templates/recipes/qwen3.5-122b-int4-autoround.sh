#!/bin/bash
# spark-vllm-mngt — github.com/sonusflow/spark-vllm-mngt
# Copyright (c) 2026 sonusflow. MIT License.
# Recipe: Qwen3.5 122B INT4 AutoRound
# Model: Qwen/Qwen3.5-122B-INT4-AutoRound
# Category: Recipes — Coding
source "$(dirname "$0")/../_common.sh"
check_connection
echo "Starting Qwen3.5 122B INT4 AutoRound on ${SPARK_HOST}..."
run_on_spark "./run-recipe.sh qwen3.5-122b-int4-autoround --solo -d"
