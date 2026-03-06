#!/bin/bash
# Recipe: MiniMax M2.5 AWQ
# Model: QuantTrio/MiniMax-M2.5-AWQ
# Category: Recipes — LLM
source "$(dirname "$0")/../_common.sh"
check_connection
echo "Starting MiniMax M2.5 AWQ on ${SPARK_HOST}..."
run_on_spark "./run-recipe.sh minimax-m2.5-awq --solo -d"
