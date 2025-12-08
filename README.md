# hyprboot

An opinionated layer on top of [hyprland-bootc](https://github.com/jfernandez/hyprland-bootc) for my personal use.

## What is this?

This is my personal Fedora bootc image. It builds on `ghcr.io/jfernandez/hyprland-bootc-nvidia-open` and adds:

- Development tools (docker, rust, nodejs, gcc, etc.)
- CLI utilities (zsh, fzf, ripgrep, starship, etc.)
- Homebrew
- 1Password
- Neovim (nightly)
- Tailscale
- Libvirt/KVM

If you're looking for a general-purpose Hyprland bootc image, check out [hyprland-bootc](https://github.com/jfernandez/hyprland-bootc) instead.

## Installation

```bash
sudo bootc switch ghcr.io/jfernandez/hyprboot:latest
```

## Verification

Images are signed with [cosign](https://github.com/sigstore/cosign). Verify with:

```bash
cosign verify --key cosign.pub ghcr.io/jfernandez/hyprboot
```
