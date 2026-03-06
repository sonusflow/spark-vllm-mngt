#!/bin/bash
# Common functions for vLLM Manager scripts
# Sourced by all recipe and utility scripts.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VLLM_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SETTINGS_FILE="$VLLM_DIR/settings.env"

if [ ! -f "$SETTINGS_FILE" ]; then
    echo "ERROR: settings.env not found at $SETTINGS_FILE"
    echo ""
    echo "Create it by editing the template:"
    echo "  open ~/.vllm/settings.env"
    exit 1
fi

source "$SETTINGS_FILE"

# Validate required settings
if [ "$SPARK_HOST" = "YOUR_DGX_IP" ] || [ -z "$SPARK_HOST" ]; then
    echo "ERROR: SPARK_HOST not configured in settings.env"
    echo "  Edit: ~/.vllm/settings.env"
    exit 1
fi

if [ "$SPARK_USER" = "YOUR_USERNAME" ] || [ -z "$SPARK_USER" ]; then
    echo "ERROR: SPARK_USER not configured in settings.env"
    echo "  Edit: ~/.vllm/settings.env"
    exit 1
fi

# Run a command on the DGX Spark via SSH
run_remote() {
    ssh $SSH_OPTS "${SPARK_USER}@${SPARK_HOST}" "$@"
}

# Run a command in the spark-vllm-docker directory on the DGX Spark
run_on_spark() {
    run_remote "cd ${SPARK_VLLM_DIR} && $*"
}

# Check if the DGX Spark is reachable
check_connection() {
    if ! ssh $SSH_OPTS -o BatchMode=yes "${SPARK_USER}@${SPARK_HOST}" "echo ok" &>/dev/null; then
        echo "ERROR: Cannot connect to ${SPARK_USER}@${SPARK_HOST}"
        echo "Check your settings.env and SSH keys."
        exit 1
    fi
}
