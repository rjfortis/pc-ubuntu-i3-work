#!/usr/bin/env bash

set -e

echo "=== Zenith NetworkManager Handover Fix ==="

# --------------------------------------
# Detect WiFi interface
# --------------------------------------

WIFI_IFACE=$(nmcli -t -f DEVICE,TYPE device status | grep ":wifi" | cut -d: -f1 | head -n1)

if [ -z "$WIFI_IFACE" ]; then
    echo "No WiFi interface detected by nmcli."
    exit 1
fi

echo "WiFi interface: $WIFI_IFACE"

# --------------------------------------
# Stop old networking stack
# --------------------------------------

echo "Stopping legacy network services..."

sudo systemctl stop systemd-networkd.service 2>/dev/null || true
sudo systemctl stop wpa_supplicant.service 2>/dev/null || true
sudo systemctl stop netplan-wpa-${WIFI_IFACE}.service 2>/dev/null || true

# --------------------------------------
# Ensure device is managed by NM
# --------------------------------------

echo "Setting device to managed..."

sudo nmcli device set "$WIFI_IFACE" managed yes || true

# --------------------------------------
# Restart NetworkManager
# --------------------------------------

echo "Restarting NetworkManager..."

sudo systemctl restart NetworkManager

sleep 3

# --------------------------------------
# Attempt connection
# --------------------------------------

CONNECTION_NAME=$(nmcli -t -f NAME,TYPE connection show | grep ":wifi" | cut -d: -f1 | head -n1)

if [ -n "$CONNECTION_NAME" ]; then
    echo "Attempting to bring up connection: $CONNECTION_NAME"
    sudo nmcli connection up "$CONNECTION_NAME" || true
else
    echo "No WiFi connection profile found in NetworkManager."
fi

# --------------------------------------
# Show final state
# --------------------------------------

echo
echo "=== Device Status ==="
nmcli device status

echo
echo "If device still shows unmanaged/unavailable, reboot is recommended."
