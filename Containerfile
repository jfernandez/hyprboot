# =============================================================================
# Hyprblue Container Image
# =============================================================================
# Hyprland desktop on Fedora bootc with NVIDIA open drivers.
# Based on wayblue's hyprland-nvidia-open configuration.
#
# Build: podman build -t hyprblue .
# =============================================================================

FROM scratch AS build-ctx
COPY build_files /build_files

FROM scratch AS system-ctx
COPY files/system /system

# Pull NVIDIA open kernel modules from ublue-os akmods
FROM ghcr.io/ublue-os/akmods-nvidia-open:main-43 AS akmods

FROM quay.io/fedora/fedora-bootc:43

# Copy NVIDIA RPMs from akmods container
COPY --from=akmods /rpms /tmp/rpms

# NVIDIA open drivers
RUN --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/cache/dnf,sharing=locked \
    --mount=type=bind,from=build-ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/install-nvidia.sh

# Desktop environment (Hyprland, SDDM, Wayland tools)
RUN --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/cache/dnf,sharing=locked \
    --mount=type=bind,from=build-ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/install-desktop.sh

# Development tools and CLI utilities
RUN --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/cache/dnf,sharing=locked \
    --mount=type=bind,from=build-ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/install-packages.sh

# 1Password (special ostree installation)
RUN --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/cache/dnf,sharing=locked \
    --mount=type=bind,from=build-ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/install-1password.sh

# Neovim nightly
RUN --mount=type=bind,from=build-ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/install-neovim.sh

# mdserve
RUN --mount=type=bind,from=build-ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/install-mdserve.sh

# System configuration files
COPY --from=system-ctx /system /

# Enable systemd services
RUN --mount=type=bind,from=build-ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/enable-services.sh

# Cleanup
RUN rm -rf /tmp/rpms /var/log/* /var/cache/* && \
    rm -rf /var/lib/dnf /var/lib/iscsi /var/lib/libvirt /var/lib/tailscale && \
    rm -rf /var/lib/containers /var/lib/docker /var/lib/rpm-state /var/lib/swtpm-localca

# Labels
LABEL org.opencontainers.image.title="hyprblue"
LABEL org.opencontainers.image.description="Hyprland desktop on Fedora bootc with NVIDIA open drivers"
LABEL containers.bootc="1"
LABEL ostree.bootable="1"

# Validate
RUN bootc container lint
