#!/usr/bin/env bash
set -ouex pipefail

# Install mdserve (markdown preview server)
MDSERVE_VERSION="${MDSERVE_VERSION:-v0.5.1}"
MDSERVE_URL="https://github.com/jfernandez/mdserve/releases/download/${MDSERVE_VERSION}/mdserve-x86_64-unknown-linux-musl"

curl -fsSL "$MDSERVE_URL" -o /usr/bin/mdserve
chmod +x /usr/bin/mdserve

# Verify
mdserve --version
