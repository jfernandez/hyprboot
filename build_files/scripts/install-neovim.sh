#!/usr/bin/env bash
set -ouex pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/lib.sh"

# Install neovim nightly
NVIM_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz"

download_with_retry "$NVIM_URL" /tmp/nvim.tar.gz
tar xzf /tmp/nvim.tar.gz -C /tmp

cp -r /tmp/nvim-linux-x86_64/bin/* /usr/bin/
cp -r /tmp/nvim-linux-x86_64/lib/* /usr/lib/
cp -r /tmp/nvim-linux-x86_64/share/* /usr/share/

rm -rf /tmp/nvim.tar.gz /tmp/nvim-linux-x86_64

# Verify
nvim --version
