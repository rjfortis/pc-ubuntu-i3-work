#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=== Starting Optimized Installation ==="

# --- System Update & Base Headers ---
sudo apt update
sudo apt full-upgrade -y
sudo apt install -y build-essential curl wget git gh rsync zip unzip xdg-utils xclip dbus-x11 htop ca-certificates software-properties-common apt-transport-https libssl-dev libyaml-dev zlib1g-dev libreadline-dev

# --- Power Management (Laptop Optimized) ---
sudo apt install -y acpi

# --- Xorg & AMD Graphics Drivers ---
# Using xserver-xorg-video-amdgpu for TearFree support without a compositor
sudo apt install -y xorg xserver-xorg-core xserver-xorg-video-amdgpu xserver-xorg-input-libinput xinit mesa-utils libvulkan1

# --- Input Devices (Touchpad Tap-to-Click & Natural Scrolling) ---
sudo apt install -y xinput libinput-tools

# --- Display Manager & Desktop Lock ---
sudo apt install -y lightdm lightdm-gtk-greeter
sudo mkdir -p /etc/lightdm/lightdm.conf.d
sudo tee /etc/lightdm/lightdm.conf.d/50-disable-wayland.conf > /dev/null <<EOF
[Seat:*]
greeter-session=lightdm-gtk-greeter
user-session=i3
EOF
sudo systemctl enable lightdm

# --- Window Manager & Environment Utilities ---
# Added lxqt-policykit for lightweight authentication
sudo apt install -y i3-wm i3status i3lock xss-lock alacritty rofi pcmanfm dunst libnotify-bin flameshot redshift lxqt-policykit

# --- Audio Stack (PipeWire) ---
sudo apt install -y pipewire pipewire-audio pipewire-pulse wireplumber pavucontrol
systemctl --user disable pulseaudio.service pulseaudio.socket 2>/dev/null || true
systemctl --user enable pipewire pipewire-pulse wireplumber

# --- Brightness Control ---
sudo apt install -y brightnessctl
sudo usermod -aG video "$USER"

# --- Storage & Automounting ---
sudo apt install -y gvfs udisks2 eject ntfs-3g exfatprogs

# Multimedia & PDF (Minimalist choices)
sudo apt install -y feh zathura sxiv

# Fonts
sudo apt install -y fonts-liberation fonts-noto-color-emoji fonts-font-awesome fonts-ubuntu fonts-cascadia-code

# Theme Support & Icons
sudo apt install -y lxappearance arc-theme papirus-icon-theme

# --- Final Cleanup ---
sudo apt autoremove -y
sudo apt clean

echo "=== Configuring Timezone and Sync ==="

# Install the time synchronization daemon
sudo apt update
sudo apt install -y systemd-timesyncd

# Set the timezone to El Salvador
# This links /etc/localtime to the correct zoneinfo
sudo timedatectl set-timezone America/El_Salvador

# Enable Network Time Protocol (NTP) sync
sudo timedatectl set-ntp true

# Show current status to verify
timedatectl status

echo "✅ Timezone set to America/El_Salvador and NTP sync enabled."

# Ensure standard folder structure (Downloads, Documents, etc.)
sudo apt install -y xdg-user-dirs
xdg-user-dirs-update

echo "=== Installation Finished. Please Reboot. ==="

sleep 3
sudo reboot
