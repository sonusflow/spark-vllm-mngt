#!/bin/bash
# spark-vllm-mngt — github.com/sonusflow/spark-vllm-mngt
# Copyright (c) 2026 sonusflow. MIT License.
# Utility: Download Model
# Downloads a HuggingFace model to the DGX Spark cache
# Usage: Set MODEL below or pass as argument
source "$(dirname "$0")/../_common.sh"
check_connection

MODEL="${1:-}"

if [ -z "$MODEL" ]; then
    echo "=== Available recipe models ==="
    echo "  QuantTrio/MiniMax-M2-AWQ"
    echo "  QuantTrio/MiniMax-M2.5-AWQ"
    echo "  Salyut1/GLM-4.7-Flash-AWQ"
    echo "  nvidia/Nemotron-3-Nano-NVFP4"
    echo "  openai/gpt-oss-120b"
    echo "  Qwen/Qwen3-Coder-Next-FP8"
    echo "  Qwen/Qwen3.5-122B-FP8"
    echo ""
    echo "Set MODEL in this script or pass as argument:"
    echo "  ~/.vllm/utilities/download-model.sh QuantTrio/MiniMax-M2-AWQ"
    exit 1
fi

echo "Downloading ${MODEL} on ${SPARK_HOST}..."
run_on_spark "./hf-download.sh ${MODEL}"
echo "Download complete."
