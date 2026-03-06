#!/bin/bash
# Recipe: Nemotron 3 Nano NVFP4
# Model: nvidia/Nemotron-3-Nano-NVFP4
# Category: Recipes — LLM
source "$(dirname "$0")/../_common.sh"
check_connection
echo "Starting Nemotron 3 Nano NVFP4 on ${SPARK_HOST}..."
run_on_spark "./run-recipe.sh nemotron-3-nano-nvfp4 --solo -d"
