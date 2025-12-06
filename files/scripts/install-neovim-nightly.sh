#!/usr/bin/env bash
set -oue pipefail

# Download and install neovim nightly
NVIM_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz"

curl -fsSL "$NVIM_URL" -o /tmp/nvim.tar.gz
tar xzf /tmp/nvim.tar.gz -C /tmp

# Install to /usr (not /usr/local which doesn't persist in ostree images)
cp -r /tmp/nvim-linux-x86_64/bin/* /usr/bin/
cp -r /tmp/nvim-linux-x86_64/lib/* /usr/lib/
cp -r /tmp/nvim-linux-x86_64/share/* /usr/share/
rm -rf /tmp/nvim.tar.gz /tmp/nvim-linux-x86_64

# Verify installation
/usr/bin/nvim --version
