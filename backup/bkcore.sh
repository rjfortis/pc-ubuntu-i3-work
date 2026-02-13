#!/usr/bin/env bash

set -e

echo "=== Zenith-OS Installation Starting ==="

# --------------------------------------------------
# System Update
# --------------------------------------------------

sudo apt update
sudo apt full-upgrade -y

# --------------------------------------------------
# Essential Base Utilities
# --------------------------------------------------

sudo apt install -y \
  build-essential \
  curl \
  wget \
  git \
  rsync zip unzip xdg-utils xclip dbus-x11 \
  htop \
  ca-certificates \
  software-properties-common \
  apt-transport-https

# --------------------------------------------------
# Power Management
# --------------------------------------------------

sudo apt install -y acpi tlp tlp-rdw
sudo systemctl enable tlp
sudo systemctl start tlp
sudo systemctl mask power-profiles-daemon.service 2>/dev/null || true

# --------------------------------------------------
# Xorg & AMD Graphics
# --------------------------------------------------

sudo apt install -y \
  xorg \
  xserver-xorg-core \
  xserver-xorg-video-amdgpu \
  xserver-xorg-input-libinput \
  xinit \
  mesa-utils libvulkan1

# AMD TearFree configuration
sudo mkdir -p /etc/X11/xorg.conf.d

sudo tee /etc/X11/xorg.conf.d/20-amdgpu.conf > /dev/null <<EOF
Section "Device"
    Identifier "AMD"
    Driver "amdgpu"
    Option "TearFree" "true"
    Option "DRI" "3"
EndSection
EOF

# --------------------------------------------------
# Display Manager
# --------------------------------------------------

sudo apt install -y \
  lightdm \
  lightdm-gtk-greeter

sudo mkdir -p /etc/lightdm/lightdm.conf.d

sudo tee /etc/lightdm/lightdm.conf.d/50-disable-wayland.conf > /dev/null <<EOF
[Seat:*]
greeter-session=lightdm-gtk-greeter
user-session=i3
EOF

sudo tee /etc/lightdm/lightdm.conf.d/60-no-flicker.conf > /dev/null <<EOF
[Seat:*]
xserver-command=X -core
EOF

sudo systemctl enable lightdm

# --------------------------------------------------
# Window Manager Environment
# --------------------------------------------------

sudo apt install -y \
  i3-wm \
  i3status \
  i3lock \
  xss-lock \
  alacritty \
  rofi \
  pcmanfm \
  dunst libnotify-bin flameshot redshift

# --------------------------------------------------
# GTK Base & Fonts
# --------------------------------------------------

sudo apt install -y \
  lxappearance \
  gtk2-engines-murrine \
  gsettings-desktop-schemas \
  gnome-themes-extra \
  adwaita-icon-theme \
  dmz-cursor-theme \
  fonts-dejavu-core \
  fonts-noto-core \
  fonts-noto-color-emoji

# --------------------------------------------------
# Audio (PipeWire)
# --------------------------------------------------

sudo apt install -y \
  pipewire \
  pipewire-audio \
  pipewire-pulse \
  wireplumber \
  libspa-0.2-bluetooth \
  pavucontrol

systemctl --user disable pulseaudio.service pulseaudio.socket 2>/dev/null || true
systemctl --user enable pipewire
systemctl --user enable wireplumber

# --------------------------------------------------
# Brightness Control
# --------------------------------------------------

sudo apt install -y brightnessctl
sudo usermod -aG video "$USER"

# --------------------------------------------------
# Input Utilities
# --------------------------------------------------

sudo apt install -y \
  xinput \
  libinput-tools

# --------------------------------------------------
# Spanish Keyboard (X11)
# --------------------------------------------------

sudo tee /etc/X11/xorg.conf.d/00-keyboard.conf > /dev/null <<EOF
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "es"
EndSection
EOF

# --------------------------------------------------
# Suspend & Lid Handling
# --------------------------------------------------

sudo sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=suspend/' /etc/systemd/logind.conf
sudo sed -i 's/#HandleLidSwitchDocked=ignore/HandleLidSwitchDocked=ignore/' /etc/systemd/logind.conf
sudo systemctl restart systemd-logind

# --------------------------------------------------
# Cleanup
# --------------------------------------------------

sudo apt autoremove -y
sudo apt clean

echo "=== Zenith-OS Installation Complete ==="
echo "Reboot recommended."

