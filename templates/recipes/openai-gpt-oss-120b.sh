#!/bin/bash
# Recipe: OpenAI GPT-OSS 120B (Cluster - 2 nodes)
# Model: openai/gpt-oss-120b
# Category: Recipes — LLM
# NOTE: Requires 2-node cluster (TP=2)
source "$(dirname "$0")/../_common.sh"
check_connection
echo "Starting OpenAI GPT-OSS 120B cluster on ${SPARK_HOST}..."
echo "NOTE: This recipe requires a 2-node cluster."
run_on_spark "./run-recipe.sh openai-gpt-oss-120b -d"
