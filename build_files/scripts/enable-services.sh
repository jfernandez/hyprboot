#!/usr/bin/env bash
set -ouex pipefail

# Enable systemd services
systemctl enable tailscaled.service
systemctl enable brew-setup.service
systemctl enable hyprblue-groups.service
