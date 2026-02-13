#!/usr/bin/env bash

# Get the absolute path of the directory where this script is located
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# Define the specific path to the tools folder
TOOLS_FOLDER="$BASE_DIR/tools"

echo "=== Starting Tool Installation from: $TOOLS_FOLDER ==="

# Check if the tools directory actually exists
if [ ! -d "$TOOLS_FOLDER" ]; then
    echo "❌ Error: Directory $TOOLS_FOLDER not found."
    exit 1
fi

# Loop through all .sh files specifically INSIDE the tools folder
for script in "$TOOLS_FOLDER"/*.sh; do
    # Check if there are actually .sh files to avoid errors in empty folders
    [ -e "$script" ] || continue

    script_name=$(basename "$script")

    echo "--> Executing tool: $script_name"

    # Run the script using bash as requested (no chmod needed)
    if bash "$script"; then
        echo "✅ $script_name finished successfully."
    else
        echo "❌ $script_name failed. Moving to next script..."
    fi

    echo "------------------------------------------"
done

echo "=== All tools in /tools have been processed! ==="
