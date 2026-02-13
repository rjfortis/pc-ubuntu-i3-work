#!/usr/bin/env bash

# Exit on error
set -e

echo "=== Installing ClamAV (CLI + GUI) ==="

# 1. Install ClamAV engine and ClamTk (GUI)
sudo apt update
sudo apt install -y clamav clamav-daemon clamtk

# 2. Stop the freshclam service to update manually the first time
# This prevents the "Locked by another process" error
sudo systemctl stop clamav-freshclam || true

# 3. Update Virus Database
echo "--> Updating Virus Database (this may take a moment)..."
sudo freshclam

# 4. Start and Enable the services
sudo systemctl enable clamav-freshclam
sudo systemctl start clamav-freshclam
sudo systemctl enable clamav-daemon
sudo systemctl start clamav-daemon

# 5. Add your user to the clamav group to avoid permission issues
sudo usermod -aG clamav "$USER"

echo "✅ ClamAV and ClamTk installed successfully!"
echo "TIP: Run 'clamtk' from Rofi to open the GUI."
