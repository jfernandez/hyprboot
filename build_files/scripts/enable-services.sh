#!/usr/bin/env bash
set -ouex pipefail

# Enable systemd services (personal additions to hyprland-bootc)

# Networking
systemctl enable tailscaled.service

# System setup
systemctl enable brew-setup.service
systemctl enable hyprboot-groups.service
