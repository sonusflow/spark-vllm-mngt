#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
APP_NAME="VLLMManager"
APP_BUNDLE="$PROJECT_DIR/$APP_NAME.app"

cd "$PROJECT_DIR"

# Generate Xcode project from project.yml
echo "==> Generating Xcode project..."
xcodegen generate --spec project.yml

# Build with xcodebuild
echo "==> Building $APP_NAME..."
xcodebuild \
    -project "$APP_NAME.xcodeproj" \
    -scheme "$APP_NAME" \
    -configuration Release \
    -derivedDataPath "$PROJECT_DIR/.build/DerivedData" \
    CODE_SIGN_IDENTITY="-" \
    CODE_SIGNING_ALLOWED=YES \
    ONLY_ACTIVE_ARCH=NO \
    build 2>&1 | tail -20

# Copy built app bundle
BUILD_PRODUCTS="$PROJECT_DIR/.build/DerivedData/Build/Products/Release"
if [ -d "$BUILD_PRODUCTS/$APP_NAME.app" ]; then
    rm -rf "$APP_BUNDLE"
    cp -r "$BUILD_PRODUCTS/$APP_NAME.app" "$APP_BUNDLE"
    echo ""
    echo "==> App bundle created: $APP_BUNDLE"
    echo ""
    echo "To install to Applications:"
    echo "  cp -r $APP_BUNDLE /Applications/"
    echo ""
    echo "To run directly:"
    echo "  open $APP_BUNDLE"
else
    echo "ERROR: Build products not found at $BUILD_PRODUCTS"
    exit 1
fi
