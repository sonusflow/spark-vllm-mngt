#!/bin/bash
# spark-vllm-mngt — github.com/sonusflow/spark-vllm-mngt
# Copyright (c) 2026 sonusflow. MIT License.
# Utility: Health Check
# Checks if vLLM API is responding on the configured port
source "$(dirname "$0")/../_common.sh"

ENDPOINT="http://${SPARK_HOST}:${VLLM_PORT}/health"

echo "Checking vLLM API at ${ENDPOINT}..."

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "$ENDPOINT" 2>/dev/null)

if [ "$HTTP_CODE" = "200" ]; then
    echo "API is healthy (HTTP $HTTP_CODE)"
    echo ""
    echo "=== Available Models ==="
    curl -s "http://${SPARK_HOST}:${VLLM_PORT}/v1/models" 2>/dev/null | python3 -m json.tool 2>/dev/null || echo "(could not parse response)"
else
    echo "API is not responding (HTTP $HTTP_CODE)"
    echo "Check if vLLM is running: use Cluster Status"
fi
