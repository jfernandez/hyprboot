# =============================================================================
# Hyprboot Container Image
# =============================================================================
# Personal Hyprland desktop built on hyprland-bootc.
#
# Build: podman build -t hyprboot .
# =============================================================================

FROM scratch AS build-ctx
COPY build_files /build_files

FROM scratch AS system-ctx
COPY files/system /system

FROM ghcr.io/jfernandez/hyprland-bootc-nvidia-open:latest

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
LABEL org.opencontainers.image.title="hyprboot"
LABEL org.opencontainers.image.description="Personal Hyprland desktop on Fedora bootc"
LABEL containers.bootc="1"
LABEL ostree.bootable="1"

# Validate
RUN bootc container lint
