#!/usr/bin/env bash
set -ouex pipefail

# Enable systemd services

# Display manager
systemctl enable sddm.service

# Networking
systemctl enable tailscaled.service

# System setup
systemctl enable brew-setup.service
systemctl enable hyprblue-groups.service
