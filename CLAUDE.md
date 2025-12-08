# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Hyprblue is a custom Fedora bootc image with Hyprland desktop. Built using a raw Containerfile on top of `quay.io/fedora/fedora-bootc:43`.

## Build Commands

```bash
# Build container image
just build

# Build with no cache (clean rebuild)
just build-clean

# Validate container image
just lint
```

## VM Testing (bcvk)

```bash
# Run persistent VM (with host storage for updates)
just run

# SSH into running VM
just ssh

# Quick ephemeral boot test
just test

# Stop/start/remove VM
just stop
just start
just rm
```

**Update workflow**:
1. Make changes and `just build` on host
2. In VM: `sudo bootc upgrade`
3. In VM: `sudo reboot`

## Architecture

**Key paths**:
- `Containerfile` - Main image definition
- `files/system/` - Files overlaid onto `/` (use `etc/` and `usr/` subdirectories)
- `build_files/scripts/` - Build scripts (install-packages.sh, install-1password.sh, etc.)
- `build_files/repos/` - Additional repo files for dnf

**Base image**: `quay.io/fedora/fedora-bootc:43`

**Published to**: `ghcr.io/jfernandez/hyprblue:latest`

**Containerfile layer caching**: The Containerfile uses split build contexts:
- `build-ctx` - Contains `build_files/` (scripts, repos)
- `system-ctx` - Contains `files/system/` (config files)

This ensures changes to `files/system/` don't invalidate the package installation layers. Only `build_files/` changes trigger full rebuilds.

## File Permissions

**IMPORTANT**: Files in `files/system/` must have proper permissions:
- Directories: `755` (rwxr-xr-x)
- Files: `644` (rw-r--r--)
- Executable scripts: `755` (rwxr-xr-x)

Restrictive permissions (700/600) will cause boot failures because systemd and other services won't be able to read the config files.

Fix permissions if needed: `chmod -R a+rX files/system/`

## Commit Guidelines

**Always use the `git-workflow` skill when creating commits or pull requests.**

Use conventional commits. Keep messages brief. No Claude Code attribution.
