#!/usr/bin/env bash
set -ouex pipefail

# Install neovim nightly
NVIM_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz"

curl -fsSL "$NVIM_URL" -o /tmp/nvim.tar.gz
tar xzf /tmp/nvim.tar.gz -C /tmp

cp -r /tmp/nvim-linux-x86_64/bin/* /usr/bin/
cp -r /tmp/nvim-linux-x86_64/lib/* /usr/lib/
cp -r /tmp/nvim-linux-x86_64/share/* /usr/share/

rm -rf /tmp/nvim.tar.gz /tmp/nvim-linux-x86_64

# Verify
nvim --version
