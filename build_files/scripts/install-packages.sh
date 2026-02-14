#!/usr/bin/env bash
set -ouex pipefail

# Add external repositories
cp /ctx/build_files/repos/*.repo /etc/yum.repos.d/

# Enable COPRs
dnf5 -y copr enable atim/starship
dnf5 -y copr enable ublue-os/packages
dnf5 -y copr enable solopasha/hyprland

# Install packages
dnf5 -y --setopt=max_parallel_downloads=20 install \
    micro \
    starship \
    flatpak-builder \
    buildah \
    distrobox \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-compose-plugin \
    nodejs \
    npm \
    gcc \
    gcc-c++ \
    make \
    bison \
    flex \
    ncurses-devel \
    elfutils-libelf-devel \
    zlib-devel \
    clang \
    libbpf-devel \
    fzf \
    git \
    ripgrep \
    zsh \
    stow \
    autojump-zsh \
    neomutt \
    tailscale \
    rust \
    cargo \
    clippy \
    rustfmt \
    openssl-devel \
    gtk4-devel \
    dbus-devel \
    libvirt \
    virt-manager \
    qemu-kvm \
    ublue-brew \
    unzip \
    wget \
    golang \
    pam-devel \
    ruby \
    rubygems \
    python3-pip \
    just \
    rpm-build \
    rpmdevtools \
    fedora-packager \
    mock \
    rpmlint \
    rust2rpm \
    cargo-rpm-macros \
    grim \
    slurp \
    wl-clipboard \
    satty \
    pipewire-alsa \
    wtype

# Disable COPRs
dnf5 -y copr disable atim/starship
dnf5 -y copr disable ublue-os/packages
dnf5 -y copr disable solopasha/hyprland

# Remove repo files (updates baked into image)
rm -f /etc/yum.repos.d/docker-ce.repo \
      /etc/yum.repos.d/tailscale.repo
