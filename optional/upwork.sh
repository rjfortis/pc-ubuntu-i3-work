#!/usr/bin/env bash

# Exit on error
set -e

# Path setup
# We look for the .deb in the 'optional' folder at the repo root
REPO_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
DEB_FILE="$REPO_ROOT/optional/upwork.deb"

echo "=== Installing Upwork Desktop App ==="

# 1. Check if the .deb file exists
if [ -f "$DEB_FILE" ]; then
    echo "--> Found: $(basename "$DEB_FILE")"
    
    # 2. Update package list to ensure dependencies can be found
    sudo apt update

    # 3. Install the local .deb file
    # Using './' or the full path is mandatory for apt to recognize it as a local file
    sudo apt install -y "$DEB_FILE"
    
    echo "✅ Upwork installed successfully."
else
    echo "❌ Error: $DEB_FILE not found."
    echo "Please ensure the .deb file is in the 'optional' folder."
    exit 1
fi

echo "=== Done! ==="
