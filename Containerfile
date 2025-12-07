# =============================================================================
# Hyprblue Container Image
# =============================================================================
# Hyprland desktop on Fedora Atomic with NVIDIA support.
# Built on wayblue's hyprland-nvidia-open image.
#
# Build: podman build -t hyprblue .
# =============================================================================

FROM scratch AS ctx
COPY build_files /build_files
COPY files/system /system

FROM ghcr.io/wayblueorg/hyprland-nvidia-open:latest

# DNF packages (repos, COPR, vanilla packages)
RUN --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/cache/dnf,sharing=locked \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/install-packages.sh

# 1Password (special ostree installation)
RUN --mount=type=cache,dst=/var/cache/libdnf5,sharing=locked \
    --mount=type=cache,dst=/var/cache/dnf,sharing=locked \
    --mount=type=bind,from=ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/install-1password.sh

# Neovim nightly
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/install-neovim.sh

# mdserve
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/install-mdserve.sh

# System configuration files
COPY --from=ctx /system /

# Enable systemd services
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    /ctx/build_files/scripts/enable-services.sh

# Cleanup bootc-incompatible paths (empty dirs recreated at boot by tmpfiles/services)
RUN rm -rf /usr/etc && \
    rm -rf /var/log/* /var/cache/* && \
    rm -rf /var/lib/dnf /var/lib/iscsi /var/lib/libvirt /var/lib/tailscale && \
    rm -rf /var/lib/containers /var/lib/docker /var/lib/rpm-state /var/lib/swtpm-localca

# Labels
LABEL org.opencontainers.image.title="hyprblue"
LABEL org.opencontainers.image.description="Hyprland desktop on Fedora Atomic with NVIDIA support"
LABEL containers.bootc="1"

# Validate
RUN bootc container lint
