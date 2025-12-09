#!/usr/bin/env bash
# Common functions for build scripts

# Download a file with retry logic for flaky connections
# Usage: download_with_retry URL DEST [MAX_RETRIES] [RETRY_DELAY]
download_with_retry() {
    local url="$1"
    local dest="$2"
    local max_retries="${3:-5}"
    local retry_delay="${4:-5}"

    for ((i=1; i<=max_retries; i++)); do
        if curl -fsSL "$url" -o "$dest"; then
            return 0
        fi
        if [[ $i -eq $max_retries ]]; then
            echo "Failed to download $url after $max_retries attempts"
            return 1
        fi
        echo "Download failed, retrying in ${retry_delay}s (attempt $i/$max_retries)..."
        sleep $retry_delay
    done
}
