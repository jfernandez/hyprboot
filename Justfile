# =============================================================================
# Hyprboot Development Justfile
# =============================================================================

export image_name := env("IMAGE_NAME", "hyprboot")
export default_tag := env("DEFAULT_TAG", "latest")
export full_image := "localhost/" + image_name + ":" + default_tag

[private]
default:
    @just --list

# =============================================================================
# Container Image Build
# =============================================================================

# Build the container image (AMD/Intel)
[group('Build')]
build:
    #!/usr/bin/env bash
    set -euo pipefail

    BUILD_ARGS=()
    if [[ -z "$(git status -s)" ]]; then
        BUILD_ARGS+=("--build-arg" "SHA_HEAD_SHORT=$(git rev-parse --short HEAD)")
    fi

    podman build \
        "${BUILD_ARGS[@]}" \
        --pull=missing \
        --tag "{{full_image}}" \
        .

# Build the NVIDIA variant
[group('Build')]
build-nvidia:
    #!/usr/bin/env bash
    set -euo pipefail

    BUILD_ARGS=()
    if [[ -z "$(git status -s)" ]]; then
        BUILD_ARGS+=("--build-arg" "SHA_HEAD_SHORT=$(git rev-parse --short HEAD)")
    fi

    podman build \
        "${BUILD_ARGS[@]}" \
        --build-arg BASE_IMAGE=ghcr.io/jfernandez/hyprland-bootc-nvidia-open:latest \
        --build-arg IMAGE_NAME=hyprboot-nvidia-open \
        --build-arg IMAGE_DESC="Opinionated Hyprland desktop on Fedora bootc with NVIDIA open drivers" \
        --pull=missing \
        --tag localhost/hyprboot-nvidia-open:{{default_tag}} \
        .

# Build all variants
[group('Build')]
build-all: build build-nvidia

# Build with no cache (clean rebuild)
[group('Build')]
build-clean:
    #!/usr/bin/env bash
    set -euo pipefail
    podman build --no-cache --pull=always --tag "{{full_image}}" .

# Build NVIDIA variant with no cache
[group('Build')]
build-clean-nvidia:
    #!/usr/bin/env bash
    set -euo pipefail
    podman build \
        --no-cache \
        --pull=always \
        --build-arg BASE_IMAGE=ghcr.io/jfernandez/hyprland-bootc-nvidia-open:latest \
        --build-arg IMAGE_NAME=hyprboot-nvidia-open \
        --build-arg IMAGE_DESC="Opinionated Hyprland desktop on Fedora bootc with NVIDIA open drivers" \
        --tag localhost/hyprboot-nvidia-open:{{default_tag}} \
        .

# Build all variants with no cache
[group('Build')]
build-clean-all: build-clean build-clean-nvidia

# =============================================================================
# VM Testing (via bcvk)
# =============================================================================

# Run ephemeral VM for quick boot testing (no persistent disk)
[group('VM')]
test: build
    bcvk ephemeral run --console {{full_image}}

# Run ephemeral VM and SSH into it
[group('VM')]
test-ssh: build
    bcvk ephemeral run-ssh {{full_image}}

# Run persistent VM with libvirt (with host storage for updates)
[group('VM')]
run: build
    bcvk libvirt run --ssh --replace --update-from-host --name {{image_name}} --filesystem btrfs {{full_image}}

# SSH into running VM
[group('VM')]
ssh:
    bcvk libvirt ssh {{image_name}}

# Stop the VM
[group('VM')]
stop:
    bcvk libvirt stop {{image_name}}

# Start a stopped VM
[group('VM')]
start:
    bcvk libvirt start {{image_name}}

# Remove VM and its resources
[group('VM')]
rm:
    bcvk libvirt rm --force {{image_name}}

# List all bcvk VMs
[group('VM')]
ps:
    bcvk libvirt list

# =============================================================================
# Disk Image Build
# =============================================================================

# Build qcow2 disk image
[group('Disk')]
build-qcow2: build
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p output
    bcvk to-disk --format qcow2 --filesystem btrfs --disk-size 20G \
        {{full_image}} output/disk.qcow2

# Build raw disk image
[group('Disk')]
build-raw: build
    #!/usr/bin/env bash
    set -euo pipefail
    mkdir -p output
    bcvk to-disk --format raw --filesystem btrfs --disk-size 20G \
        {{full_image}} output/disk.raw

# =============================================================================
# Utility
# =============================================================================

# Validate container image passes bootc lint
[group('Utility')]
lint:
    podman run --rm {{full_image}} bootc container lint

# Clean build artifacts
[group('Utility')]
clean:
    rm -rf output/

# Clean all (including container images and VMs)
[group('Utility')]
clean-all: clean
    -bcvk libvirt rm {{image_name}} 2>/dev/null
    -podman rmi {{full_image}}
