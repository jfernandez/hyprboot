#!/usr/bin/env bash
set -oue pipefail

# Enable hyprblue-groups service to add wheel users to docker/libvirt groups at boot
systemctl enable hyprblue-groups.service
