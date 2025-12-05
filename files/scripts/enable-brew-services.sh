#!/usr/bin/env bash
set -oue pipefail

# Enable homebrew setup service (extracts brew on first boot)
systemctl enable brew-setup.service
