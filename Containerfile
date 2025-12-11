# =============================================================================
# Hyprboot Container Image
# =============================================================================
# Opinionated Hyprland desktop built on hyprland-bootc.
#
# Build:
#   podman build -t hyprboot .                          # AMD/Intel (default)
#   podman build \
#     --build-arg BASE_IMAGE=ghcr.io/jfernandez/hyprland-bootc-nvidia-open:latest \
#     --build-arg IMAGE_NAME=hyprboot-nvidia-open \
#     --build-arg IMAGE_DESC="Opinionated Hyprland desktop on Fedora bootc with NVIDIA open drivers" \
#     -t hyprboot-nvidia-open .
# =============================================================================

ARG BASE_IMAGE=ghcr.io/jfernandez/hyprland-bootc:latest
ARG IMAGE_NAME=hyprboot
ARG IMAGE_DESC="Opinionated Hyprland desktop on Fedora bootc"

FROM scratch AS build-ctx
COPY build_files /build_files

FROM scratch AS system-ctx
COPY files/system /system

FROM ${BASE_IMAGE}

# Re-declare ARGs after FROM (they reset after each FROM)
ARG IMAGE_NAME
ARG IMAGE_DESC

# Development tools and CLI utilities
RUN --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/cache/dnf,sharing=locked \
    --mount=type=bind,from=build-ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/install-packages.sh

# 1Password
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

# Google Chrome
RUN --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/cache/dnf,sharing=locked \
    --mount=type=bind,from=build-ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/install-chrome.sh

# System configuration files
COPY --from=system-ctx /system /

# Enable systemd services
RUN --mount=type=bind,from=build-ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/enable-services.sh

# Cleanup
RUN rm -rf /var/log/* /var/cache/* && \
    rm -rf /var/lib/dnf /var/lib/iscsi /var/lib/libvirt /var/lib/tailscale && \
    rm -rf /var/lib/containers /var/lib/docker /var/lib/rpm-state /var/lib/swtpm-localca

# Labels
LABEL org.opencontainers.image.title=$IMAGE_NAME
LABEL org.opencontainers.image.description=$IMAGE_DESC
LABEL containers.bootc="1"
LABEL ostree.bootable="1"

# Validate
RUN bootc container lint
