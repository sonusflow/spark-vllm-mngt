#!/bin/bash
# Recipe: Qwen3 Coder Next FP8
# Model: Qwen/Qwen3-Coder-Next-FP8
# Category: Recipes — Coding
source "$(dirname "$0")/../_common.sh"
check_connection
echo "Starting Qwen3 Coder Next FP8 on ${SPARK_HOST}..."
run_on_spark "./run-recipe.sh qwen3-coder-next-fp8 --solo -d"
