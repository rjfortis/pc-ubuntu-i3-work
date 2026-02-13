#!/usr/bin/env bash

# Use the script location as the base path
REPO_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "=== Linking Dotfiles from: $REPO_PATH ==="

link_config() {
    local src="$REPO_PATH/$1"
    local dest="$HOME/.config/$2"

    if [ -e "$src" ]; then
        mkdir -p "$(dirname "$dest")"
        ln -sf "$src" "$dest"
        echo "Successfully linked: $2"
    else
        echo "Warning: Source $src not found. Skipping."
    fi
}

# Link bashrc from your project to your home directory
if [ -f "$REPO_PATH/config/bashrc" ]; then
    ln -sf "$REPO_PATH/config/bashrc" "$HOME/.bashrc"
    echo "Successfully linked: .bashrc"
fi

# Link GTK 2.0 config (Legacy apps)
if [ -f "$REPO_PATH/config/gtkrc-2.0" ]; then
    ln -sf "$REPO_PATH/config/gtkrc-2.0" "$HOME/.gtkrc-2.0"
    echo "Successfully linked: .gtkrc-2.0"
fi

# --- Window Manager & Status ---
link_config "config/i3/config" "i3/config"
link_config "config/i3status/config" "i3status/config"

# --- Appearance (GTK 3.0) ---
# This ensures Arc-Dark is applied to modern apps
link_config "config/gtk-3.0/settings.ini" "gtk-3.0/settings.ini"

# --- Terminal & Apps ---
link_config "config/alacritty/alacritty.toml" "alacritty/alacritty.toml"
# link_config "config/zed/settings.json" "zed/settings.json"
# link_config "config/dunst/dunstrc" "dunst/dunstrc"


echo "=== Done! All configs are now managed via symlinks ==="
