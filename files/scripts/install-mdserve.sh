#!/usr/bin/env bash
set -oue pipefail

# Download and install mdserve (markdown preview server)
# Using musl build for static linking - no glibc version dependencies
MDSERVE_VERSION="v0.5.1"
MDSERVE_URL="https://github.com/jfernandez/mdserve/releases/download/${MDSERVE_VERSION}/mdserve-x86_64-unknown-linux-musl"

curl -fsSL "$MDSERVE_URL" -o /usr/bin/mdserve
chmod +x /usr/bin/mdserve

# Verify installation
/usr/bin/mdserve --version
