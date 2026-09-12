# HyprX

HyprX is a complete Hyprland desktop installer and adaptive Quickshell interface for a minimal pacman-based Linux system. The operating-system base is installed separately; HyprX installs Hyprland, the desktop software it needs, and the complete HyprX layout.

## Install

Clone the repository and run the Hyprland installer as your normal user:

```bash
git clone https://github.com/Gwar17/HyprX.git
cd HyprX
./bootstrap/install-hyprland.sh
```

The installer installs Hyprland, Quickshell, Kitty, Dolphin, Rofi, VSCodium, MPV, Firefox, `yazi-git`, AWWW, Hyprpicker, PipeWire/WirePlumber, NetworkManager and Bluetooth tooling, portals, lock/idle/sunset utilities, fonts/icons, SDDM, and the supporting desktop utilities. `paru` is installed automatically when it is not already available.

A remote bootstrap entry point is also included:

```bash
curl -fsSL https://raw.githubusercontent.com/Gwar17/HyprX/main/bootstrap.sh | bash
```

## Hyprland configuration

HyprX uses **Hyprland Lua configuration only**. A fresh installation receives `hypr/hyprland.lua`. If `~/.config/hypr/hyprland.lua` already exists, the installer backs it up and preserves it, replacing only the guarded HyprX block:

```lua
-- HYPRX:BEGIN
dofile(os.getenv("HOME") .. "/.config/hypr/hyprx/colors.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/hyprx/keybinds.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/hyprx/autostart.lua")
-- HYPRX:END
```

Managed backups are stored under `~/.local/state/hyprx/backups/`.

## Island

The island is one top-pinned Quickshell surface. Its collapsed state is a small top-centred clock pill, and it morphs in **360 ms** between launcher, media, theme, wallpaper, control center, notifications and power/session modes. The shell stays neutral translucent black; theme colors are used as functional accents for focus, selection, toggles, sliders and swatches.

Theme and wallpaper lists are discovered at runtime. Applications come from desktop entries, media uses MPRIS, and notifications are native Quickshell using the HyprX/Nova visual language.

## Themes and wallpapers

HyprX ships nine palettes: Catppuccin, E-ink, Emerald, Everforest, Gruvbox, Nord, Onedark, Rose Pine and TokyoNight.

`hyprx-theme THEME` updates the active palette and synchronizes Hyprland Lua colors, Kitty, Rofi, KDE/Dolphin, Yazi, VSCodium and GTK preferences. Default theme wallpapers live inside each theme directory; selectable wallpaper collections are installed to `~/Pictures/Wallpapers/<Theme>/`. AWWW is the wallpaper backend.

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
  packages.aur
hypr/
  hyprland.lua
hyprx/
  colors.lua
  keybinds.lua
  autostart.lua
quickshell/hyprx/
apps/
greeter/hyprx/
scripts/
theme/
wallpapers/
```

Hyprland integration is Lua-based; there is no parallel `hyprland.conf` configuration tree.
