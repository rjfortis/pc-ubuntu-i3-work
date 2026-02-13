#!/usr/bin/env bash

set -e

echo "=== Zenith WiFi Migration (Netplan → NetworkManager) ==="

# --------------------------------------
# Detect netplan file
# --------------------------------------

NETPLAN_FILE=$(sudo ls /etc/netplan/*.yaml | head -n 1)

if [ -z "$NETPLAN_FILE" ]; then
    echo "No netplan file found."
    exit 1
fi

echo "Using netplan file: $NETPLAN_FILE"

# --------------------------------------
# Extract WiFi interface
# --------------------------------------

WIFI_IFACE=$(sudo grep -A1 "wifis:" "$NETPLAN_FILE" | tail -n1 | awk '{print $1}' | sed 's/://')

if [ -z "$WIFI_IFACE" ]; then
    echo "No WiFi interface found."
    exit 1
fi

echo "Detected interface: $WIFI_IFACE"

# --------------------------------------
# Extract SSID and password
# --------------------------------------

SSID=$(sudo grep -A2 "access-points:" "$NETPLAN_FILE" | grep '"' | head -n1 | cut -d'"' -f2)
PASSWORD=$(sudo grep "password:" "$NETPLAN_FILE" | cut -d'"' -f2)

if [ -z "$SSID" ] || [ -z "$PASSWORD" ]; then
    echo "Could not extract SSID or password."
    exit 1
fi

echo "Found network: $SSID"

# --------------------------------------
# Install NetworkManager
# --------------------------------------

sudo apt update
sudo apt install -y network-manager

# --------------------------------------
# Switch netplan renderer
# --------------------------------------

sudo cp "$NETPLAN_FILE" "${NETPLAN_FILE}.backup"

sudo tee "$NETPLAN_FILE" > /dev/null <<EOF
network:
  version: 2
  renderer: NetworkManager
EOF

sudo netplan generate

# --------------------------------------
# Enable NetworkManager
# --------------------------------------

sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

# --------------------------------------
# Stop old stack (clean takeover)
# --------------------------------------

sudo systemctl stop systemd-networkd.service || true
sudo systemctl stop systemd-networkd-wait-online.service || true
sudo systemctl stop wpa_supplicant.service || true

# --------------------------------------
# Disable old stack permanently
# --------------------------------------

sudo systemctl disable systemd-networkd.service || true
sudo systemctl disable systemd-networkd-wait-online.service || true

sudo systemctl mask systemd-networkd.service || true
sudo systemctl mask systemd-networkd-wait-online.service || true

# --------------------------------------
# Restart NM to claim device
# --------------------------------------

sudo systemctl restart NetworkManager.service

# --------------------------------------
# Ensure device is managed
# --------------------------------------

sudo nmcli device set "$WIFI_IFACE" managed yes || true

# --------------------------------------
# Add connection if not exists
# --------------------------------------

if ! nmcli connection show | grep -q "$SSID"; then
    sudo nmcli connection add \
        type wifi \
        ifname "$WIFI_IFACE" \
        con-name "$SSID" \
        ssid "$SSID"

    sudo nmcli connection modify "$SSID" \
        wifi-sec.key-mgmt wpa-psk \
        wifi-sec.psk "$PASSWORD"
fi

# --------------------------------------
# Bring connection up
# --------------------------------------

sudo nmcli connection up "$SSID" || true

sudo netplan apply

echo "=== Migration Complete ==="
echo "Reboot recommended."
