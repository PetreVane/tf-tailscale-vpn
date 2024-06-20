#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status.
set -u  # Treat unset variables as an error.

# Redirect output and error to a log file
exec > /var/log/tailscale_setup_debug.log 2>&1
sudo su
echo "Starting Tailscale setup at $(date)..."

# Update package lists
echo "Updating package lists..."
sudo apt update || { echo "apt update failed"; exit 1; }

# Install necessary packages
echo "Installing necessary packages..."
sudo apt -qq install software-properties-common apt-transport-https ca-certificates lsb-release curl -y || { echo "Package installation failed"; exit 1; }

# Add Tailscale GPG key and repository
echo "Adding Tailscale GPG key and repository..."
curl -fsSL "https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg" | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null || { echo "Adding GPG key failed"; exit 1; }
curl -fsSL "https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list" | sudo tee /etc/apt/sources.list.d/tailscale.list || { echo "Adding repository failed"; exit 1; }

# Update package lists again after adding new repository
echo "Updating package lists after adding Tailscale repository..."
sudo apt update || { echo "apt update after adding repository failed"; exit 1; }

# Install Tailscale package
echo "Installing Tailscale package..."
sudo apt -qq install tailscale -y || { echo "Installing Tailscale failed"; exit 1; }

# Enable IPv4 and IPv6 forwarding
echo "Enabling IPv4 and IPv6 forwarding..."
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf || { echo "IPv4 forwarding configuration failed"; exit 1; }
sudo sed -i 's/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/' /etc/sysctl.conf || { echo "IPv6 forwarding configuration failed"; exit 1; }
sudo sysctl -p || { echo "Applying sysctl changes failed"; exit 1; }

# Start and enable Tailscale
echo "Starting and enabling Tailscale..."
sudo tailscale up --advertise-exit-node --hostname="${hostname}-${region}" --authkey="${authkey}" || { echo "Starting Tailscale failed"; exit 1; }
sudo systemctl enable --now tailscaled || { echo "Enabling tailscaled service failed"; exit 1; }

echo "Tailscale setup completed at $(date)."
