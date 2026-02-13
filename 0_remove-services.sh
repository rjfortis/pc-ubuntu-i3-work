#!/usr/bin/env bash

set -e

echo "=== Zenith-OS Service Hardening ==="

# --------------------------------------
# CLOUD-INIT
# --------------------------------------

sudo systemctl stop cloud-init.service cloud-init-local.service cloud-config.service cloud-final.service || true
sudo systemctl disable cloud-init.service cloud-init-local.service cloud-config.service cloud-final.service || true
sudo systemctl mask cloud-init.service cloud-init-local.service cloud-config.service cloud-final.service || true

# --------------------------------------
# SNAPD
# --------------------------------------

sudo systemctl stop snapd.service snapd.socket snapd.seeded.service || true
sudo systemctl disable snapd.service snapd.socket snapd.seeded.service || true
sudo systemctl mask snapd.service snapd.socket snapd.seeded.service || true

# --------------------------------------
# MODEM STACK
# --------------------------------------

sudo systemctl stop ModemManager.service || true
sudo systemctl disable ModemManager.service || true
sudo systemctl mask ModemManager.service || true

# --------------------------------------
# LXD
# --------------------------------------

sudo systemctl stop lxd-agent.service lxd-agent-loader.service || true
sudo systemctl disable lxd-agent.service lxd-agent-loader.service || true
sudo systemctl mask lxd-agent.service lxd-agent-loader.service || true

# --------------------------------------
# PACKAGEKIT
# --------------------------------------

sudo systemctl stop packagekit.service || true
sudo systemctl disable packagekit.service || true
sudo systemctl mask packagekit.service || true

# -
# Multipathd
# -

sudo systemctl stop multipathd.service multipathd.socket
sudo systemctl disable multipathd.service multipathd.socket
sudo systemctl mask multipathd.service multipathd.socket

# --------------------------------------
# CLEAN DAEMON RELOAD
# --------------------------------------

sudo systemctl daemon-reload

echo "=== Hardening Complete ==="
echo "Reboot."

sleep 5

sudo reboot
