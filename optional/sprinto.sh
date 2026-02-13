#!/usr/bin/env bash

# Exit on error
set -e

# Path setup
TOOLS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP_NAME="drsprinto"
APP_IMAGE="drsprinto.AppImage"
TARGET_DIR="$HOME/Applications"
DESKTOP_FILE="$HOME/.local/share/applications/$APP_NAME.desktop"

echo "=== Installing $APP_NAME AppImage ==="

# 1. Install FUSE dependencies (Required for AppImages)
echo "--> Installing fuse and libfuse2..."
sudo apt update
sudo apt install -y fuse libfuse2

# 2. Prepare target directory
mkdir -p "$TARGET_DIR"

# 3. Copy the AppImage
if [ -f "$TOOLS_DIR/$APP_IMAGE" ]; then
    cp "$TOOLS_DIR/$APP_IMAGE" "$TARGET_DIR/$APP_IMAGE"
    echo "✅ Copied $APP_IMAGE to $TARGET_DIR"
else
    echo "❌ Error: $APP_IMAGE not found in $TOOLS_DIR"
    exit 1
fi

# 4. Set execution permissions
chmod +x "$TARGET_DIR/$APP_IMAGE"
echo "✅ Permissions set: executable"

# 5. Create Desktop Entry with --no-sandbox flag
mkdir -p "$HOME/.local/share/applications"

# We add --no-sandbox to the Exec line to avoid Chromium sandbox issues
cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Name=DrSprinto
Exec=$TARGET_DIR/$APP_IMAGE --no-sandbox
Icon=system-run
Type=Application
Categories=Utility;
Terminal=false
Comment=Run DrSprinto with No Sandbox
EOF

echo "✅ Desktop Entry created with --no-sandbox flag"
echo "=== Done! Search for '$APP_NAME' in Rofi ==="
