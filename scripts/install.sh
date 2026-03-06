#!/bin/bash
set -euo pipefail

VLLM_DIR="$HOME/.vllm"
CONFIG_FILE="$VLLM_DIR/config.json"
SETTINGS_FILE="$VLLM_DIR/settings.env"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATE_DIR="$PROJECT_DIR/templates"

echo "==> Setting up vLLM Manager..."

# Create directory structure
mkdir -p "$VLLM_DIR/recipes"
mkdir -p "$VLLM_DIR/utilities"
echo "    Created $VLLM_DIR/{recipes,utilities}"

# Copy common script (always update)
cp "$TEMPLATE_DIR/_common.sh" "$VLLM_DIR/_common.sh"
echo "    Installed _common.sh"

# Copy settings.env (preserve existing)
if [ ! -f "$SETTINGS_FILE" ]; then
    cp "$TEMPLATE_DIR/settings.env" "$SETTINGS_FILE"
    echo "    Created settings: $SETTINGS_FILE"
    echo "    *** EDIT THIS FILE with your DGX Spark connection details ***"
else
    echo "    Settings already exists: $SETTINGS_FILE (not overwritten)"
fi

# Copy recipe scripts
echo "    Installing recipe scripts..."
for script in "$TEMPLATE_DIR"/recipes/*.sh; do
    [ -f "$script" ] || continue
    cp "$script" "$VLLM_DIR/recipes/"
    chmod +x "$VLLM_DIR/recipes/$(basename "$script")"
done
echo "    Installed $(ls "$TEMPLATE_DIR"/recipes/*.sh 2>/dev/null | wc -l | tr -d ' ') recipes"

# Copy utility scripts
echo "    Installing utility scripts..."
for script in "$TEMPLATE_DIR"/utilities/*.sh; do
    [ -f "$script" ] || continue
    cp "$script" "$VLLM_DIR/utilities/"
    chmod +x "$VLLM_DIR/utilities/$(basename "$script")"
done
echo "    Installed $(ls "$TEMPLATE_DIR"/utilities/*.sh 2>/dev/null | wc -l | tr -d ' ') utilities"

# Let app generate default config on first launch (don't write static JSON)
if [ ! -f "$CONFIG_FILE" ]; then
    echo "    Config will be generated on first app launch"
else
    echo "    Config already exists: $CONFIG_FILE"
fi

# Build and install app
echo ""
echo "==> Building app..."
bash "$SCRIPT_DIR/build-app.sh"

APP_BUNDLE="$PROJECT_DIR/VLLMManager.app"
if [ -d "$APP_BUNDLE" ]; then
    echo ""
    echo "==> Installing to /Applications..."
    cp -r "$APP_BUNDLE" /Applications/
    echo "    Installed to /Applications/VLLMManager.app"
    echo ""
    echo "==> Setup complete!"
    echo ""
    echo "    1. Edit your connection settings:"
    echo "       nano $SETTINGS_FILE"
    echo ""
    echo "    2. Launch the app:"
    echo "       open /Applications/VLLMManager.app"
    echo ""
    echo "    3. Add the Notification Center widget:"
    echo "       Click date/time in menu bar > Edit Widgets > search 'vLLM'"
    echo ""
    echo "    Scripts: $VLLM_DIR/{recipes,utilities}/"
    echo "    Config:  $CONFIG_FILE"
fi
