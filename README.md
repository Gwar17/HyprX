# HyprX

HyprX is a complete Hyprland desktop installer and adaptive Quickshell interface for a minimal pacman-based Linux system. The operating-system base is installed separately; HyprX installs Hyprland, the desktop software it needs, and the complete HyprX layout.

## Install

Clone the repository and run the Hyprland installer as your normal user:

```bash
git clone https://github.com/Gwar17/HyprX.git
cd HyprX
./bootstrap/install-hyprland.sh
```

The installer installs the current HyprX desktop layer: Hyprland with UWSM, Quickshell, Kitty, Dolphin, Rofi, MPV, Firefox, `awww`, Hyprpicker, PipeWire/WirePlumber, NetworkManager and Bluetooth tooling, portals, lock/idle/sunset utilities, fonts/icons, SDDM, and supporting desktop utilities. HyprX uses the official repository package set only; there is no automatic AUR or `paru` path.
A remote bootstrap entry point is also included:

```bash
curl -fsSL https://raw.githubusercontent.com/Gwar17/HyprX/main/bootstrap.sh | bash
```

## Hyprland configuration

HyprX uses **Hyprland Lua configuration only**. The installer backs up any existing Hyprland configuration, then installs the clean HyprX-owned `hypr/hyprland.lua` as the active configuration.
```

Managed backups are stored under `~/.local/state/hyprx/backups/`.

## Island

The island is one top-pinned Quickshell surface. Its collapsed state is a small top-centred clock pill, and it morphs in **360 ms** between launcher, media, theme, wallpaper, control center, notifications and power/session modes. The shell stays neutral translucent black; theme colors are used as functional accents for focus, selection, toggles, sliders and swatches.

Theme and wallpaper lists are discovered at runtime. Applications come from desktop entries, media uses MPRIS, and notifications are native Quickshell using the HyprX/Nova visual language.

## Themes and wallpapers

HyprX ships nine palettes: Catppuccin, E-ink, Emerald, Everforest, Gruvbox, Nord, Onedark, Rose Pine and TokyoNight.

`hyprx-theme THEME` updates the active palette and synchronizes Hyprland Lua colors, Kitty, Rofi, and KDE/Dolphin. Wallpapers are managed independently through `hyprx-wallpaper` with `awww` as the backend.
## Key bindings

- `Super+Return` — Kitty
- `Super+E` — Dolphin
- `Super+R` — Rofi fallback launcher
- `Super+Space` / `Super+A` — HyprX launcher
- `Super+X` — control center
- `Super+T` — themes
- `Super+W` — wallpapers
- `Super+N` — notifications
- `Super+M` — media
- `Super+Shift+P` — power/session
- `Super+Shift+C` — Hyprpicker
- `Super+Shift+W` — random wallpaper

## Shell and terminal surface

Bash is the default choice and Fish is available during installation or later with `hyprx-shell fish`. Switch back with `hyprx-shell bash`. Both use the same deliberately minimal prompt style; Fish keeps its native interactive syntax highlighting.

Terminal presentation is independent of the active color palette. `hyprx-surface matte`, `minimal`, `gloss`, or `glass` changes Kitty's surface/transparency while preserving the active HyprX colors. `minimal` is the default.

## Repository layout

```text
bootstrap.sh
bootstrap/
  install-hyprland.sh
  packages.repo
hypr/
  hyprland.lua
hyprx/
  colors.lua
  keybinds.lua
quickshell/hyprx/
apps/
greeter/hyprx/
scripts/
theme/
wallpapers/
```

Hyprland integration is Lua-based; there is no parallel `hyprland.conf` configuration tree.
