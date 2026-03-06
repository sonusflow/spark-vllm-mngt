#!/bin/bash
# Recipe: Qwen3.5 35B-A3B FP8
# Model: Qwen/Qwen3.5-35B-A3B-FP8
# Category: Recipes — Coding
source "$(dirname "$0")/../_common.sh"
check_connection
echo "Starting Qwen3.5 35B-A3B FP8 on ${SPARK_HOST}..."
run_on_spark "./run-recipe.sh qwen35-35b-a3b-fp8 --solo -d"
