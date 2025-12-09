#!/usr/bin/env bash
set -ouex pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/lib.sh"

# Install mdserve (markdown preview server)
MDSERVE_VERSION="${MDSERVE_VERSION:-v0.5.1}"
MDSERVE_URL="https://github.com/jfernandez/mdserve/releases/download/${MDSERVE_VERSION}/mdserve-x86_64-unknown-linux-musl"

download_with_retry "$MDSERVE_URL" /usr/bin/mdserve
chmod +x /usr/bin/mdserve

# Verify
mdserve --version
