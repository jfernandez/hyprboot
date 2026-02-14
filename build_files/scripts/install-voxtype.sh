#!/usr/bin/env bash
set -ouex pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
source "$SCRIPT_DIR/lib.sh"

VOXTYPE_VERSION="0.5.5"
VOXTYPE_URL="https://github.com/peteonrails/voxtype/releases/download/v${VOXTYPE_VERSION}/voxtype-${VOXTYPE_VERSION}-1.x86_64.rpm"

download_with_retry "$VOXTYPE_URL" /tmp/voxtype.rpm
dnf5 install -y /tmp/voxtype.rpm
rm /tmp/voxtype.rpm

voxtype --version
