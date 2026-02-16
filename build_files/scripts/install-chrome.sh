#!/usr/bin/env bash
set -ouex pipefail

# Google Chrome installation (direct RPM download, no repo)

curl -fsSL -o /tmp/google-chrome.rpm \
    https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm

dnf5 install -y /tmp/google-chrome.rpm
rm /tmp/google-chrome.rpm

# Remove Google Chrome repo (installed from direct RPM, not needed at runtime)
rm -f /etc/yum.repos.d/google-chrome.repo
