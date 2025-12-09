#!/usr/bin/env bash
set -ouex pipefail

# Enable systemd services (personal additions to hyprland-bootc)

# Networking
systemctl enable tailscaled.service

# System setup
systemctl enable brew-setup.service
systemctl enable hyprboot-groups.service

# Mask units that don't work on bootc
# remount-fs fails because root is a composefs overlay, not the btrfs in fstab
systemctl mask systemd-remount-fs.service
