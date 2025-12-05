#!/usr/bin/env bash
set -oue pipefail

# Download and install neovim nightly
NVIM_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz"

curl -fsSL "$NVIM_URL" -o /tmp/nvim.tar.gz
tar xzf /tmp/nvim.tar.gz -C /tmp
cp -r /tmp/nvim-linux-x86_64/* /usr/local/
rm -rf /tmp/nvim.tar.gz /tmp/nvim-linux-x86_64

# Verify installation
/usr/local/bin/nvim --version
