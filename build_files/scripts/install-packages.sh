#!/usr/bin/env bash
set -ouex pipefail

# Add external repositories
cp /ctx/build_files/repos/*.repo /etc/yum.repos.d/

# Enable COPRs
dnf5 -y copr enable atim/starship
dnf5 -y copr enable ublue-os/packages

# Install packages
dnf5 -y --setopt=max_parallel_downloads=20 install \
    micro \
    starship \
    ostree \
    rpm-ostree \
    flatpak-builder \
    podman \
    buildah \
    skopeo \
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
    curl \
    fzf \
    git \
    ripgrep \
    zsh \
    stow \
    autojump-zsh \
    gnupg2 \
    openssl \
    neomutt \
    tailscale \
    ublue-brew \
    libvirt \
    virt-manager \
    qemu-kvm

# Disable COPRs
dnf5 -y copr disable atim/starship
dnf5 -y copr disable ublue-os/packages

# Remove repo files (updates baked into image)
rm -f /etc/yum.repos.d/docker-ce.repo \
      /etc/yum.repos.d/tailscale.repo
