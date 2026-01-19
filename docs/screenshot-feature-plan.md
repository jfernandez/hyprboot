# Screenshot Feature Implementation

## Overview
Screenshot functionality with region selection and app launcher integration.

## Implementation (Simplified)

Based on review feedback, the implementation was simplified:
- **No wayfreeze** - Simpler build, screenshot still works
- **Region mode only** - Just region selection, no window/fullscreen modes
- **No keybindings** - Users configure their own bindings
- **XDG output** - Screenshots saved to `~/Pictures/Screenshots/`

## Components

### 1. Packages (`build_files/scripts/install-packages.sh`)
Added to dnf5 install:
- `grim` - Wayland screenshot capture
- `slurp` - Region selector
- `wl-clipboard` - Clipboard integration (wl-copy)
- `satty` - Screenshot editor (from `solopasha/hyprland` COPR)

### 2. Screenshot Script (`files/system/usr/bin/hyprboot-screenshot`)
Simple region selection script:
- Default: Region selection → satty editor → copy to clipboard on save
- `--clipboard` flag: Region selection → direct to clipboard (no editor)

### 3. Desktop Entry (`files/system/usr/share/applications/hyprboot-screenshot.desktop`)
Allows launching from app launcher (wofi/walker).

## Usage

```bash
# Interactive region selection, opens in satty editor
hyprboot-screenshot

# Direct to clipboard without editor
hyprboot-screenshot --clipboard
```

## Optional Keybindings (user-configured)

Add to your Hyprland config:
```
bind = , PRINT, exec, hyprboot-screenshot
bind = SHIFT, PRINT, exec, hyprboot-screenshot --clipboard
```

## Files Changed/Created

| File | Status |
|------|--------|
| `build_files/scripts/install-packages.sh` | Modified |
| `files/system/usr/bin/hyprboot-screenshot` | Created (755) |
| `files/system/usr/share/applications/hyprboot-screenshot.desktop` | Created (644) |
