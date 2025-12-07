# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a BlueBuild repository for creating a custom Fedora Atomic image called "hyprblue". It builds on top of Wayblue's hyprland-nvidia-open image, which provides Hyprland with open-source NVIDIA drivers.

## Build Commands

Local builds require the BlueBuild CLI (pre-installed on BlueBuild images):

```bash
# Generate Containerfile from recipe (preview build config)
bluebuild generate recipes/recipe.yml

# Build image locally
bluebuild build recipes/recipe.yml

# Build and deploy to current system (exports tar.gz, rebases via rpm-ostree)
bluebuild switch recipes/recipe.yml
```

## Architecture

**Recipe-driven build system**: The `recipes/recipe.yml` file defines the image through ordered modules:

1. **files** - Copies `files/system/*` into the image root
2. **dnf** - Manages RPM packages and COPR repos
3. **default-flatpaks** - Configures system/user flatpaks
4. **signing** - Sets up image signing policy

**Key paths**:
- `recipes/recipe.yml` - Main image definition
- `files/system/` - Files overlaid onto `/` (use `etc/` and `usr/` subdirectories)
- `files/scripts/` - Custom build scripts (referenced via `script` module type)
- `modules/` - Custom module definitions

**Base image**: `ghcr.io/wayblueorg/hyprland-nvidia-open:latest`

**Published to**: `ghcr.io/jfernandez/hyprblue:latest`

## Recipe Schema

The recipe uses the BlueBuild v1 schema: `https://schema.blue-build.org/recipe-v1.json`

Available module types: `files`, `dnf`, `rpm-ostree`, `default-flatpaks`, `script`, `signing`, and others documented at https://blue-build.org/reference/modules/

## Commit Guidelines

**Always use the `git-workflow` skill when creating commits or pull requests.**

Use conventional commits. Keep messages brief. No Claude Code attribution.
