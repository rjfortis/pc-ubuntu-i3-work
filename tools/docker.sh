#!/usr/bin/env bash

# Exit on error, undefined vars, and pipe failures
set -euo pipefail

echo "=== Installing Docker & Docker Compose ==="

# 1. Install Docker and plugins via APT
# In Ubuntu, these are the standard package names
sudo apt update
sudo apt install -y \
    docker.io \
    docker-compose-v2 \
    docker-buildx

# 2. Enable and start Docker service
sudo systemctl enable --now docker.service

# 3. Create docker group and add current user
# -f force to not fail if group already exists
sudo groupadd -f docker
sudo usermod -aG docker "$USER"

# 4. Verification
echo "--------------------------------------------------"
docker --version
docker compose version
echo "Installation complete."
echo "IMPORTANT: Log out and log back in to apply group changes."
echo "Or run: newgrp docker (for the current terminal session)"
echo "--------------------------------------------------"
