#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"; EDGE=0; FISH=0
for x in "$@"; do case "$x" in --edge) EDGE=1;; --fish) FISH=1;; -h|--help) echo 'Usage: ./install.sh [--edge] [--fish]'; exit;; *) echo "Unknown option: $x" >&2; exit 2;; esac; done
log(){ printf '\033[1;36m[HyprX]\033[0m %s\n' "$*"; }
[[ $EUID -ne 0 ]] || { echo 'Run as your normal user.' >&2; exit 1; }
command -v pacman >/dev/null || { echo 'Arch Linux/derivative required.' >&2; exit 1; }
if ! command -v paru >/dev/null; then
 log 'Installing paru'; sudo pacman -S --needed --noconfirm base-devel git
 t="$(mktemp -d)"; git clone --depth 1 https://aur.archlinux.org/paru.git "$t/paru"; (cd "$t/paru" && makepkg -si --noconfirm); rm -rf "$t"
fi
qs_pkg=quickshell; ((EDGE)) && qs_pkg=quickshell-git
log "Installing $qs_pkg and desktop dependencies"
paru -S --needed --noconfirm "$qs_pkg" awww wl-clipboard cliphist pipewire wireplumber brightnessctl playerctl kitty dolphin fish inter-font ttf-jetbrains-mono-nerd papirus-icon-theme qt6-imageformats
mkdir -p "$CFG/quickshell" "$CFG/hypr/hyprx" "$CFG/hyprx" "$HOME/.local/bin" "$HOME/Pictures/Wallpapers/HyprX"
rm -rf "$CFG/quickshell/hyprx"; cp -a "$ROOT/quickshell/hyprx" "$CFG/quickshell/hyprx"
cp -a "$ROOT/hyprx/." "$CFG/hypr/hyprx/"; cp "$ROOT/theme/theme.env" "$CFG/hyprx/theme.env"
install -m755 "$ROOT/scripts/hyprx-wallpaper" "$HOME/.local/bin/"; install -m755 "$ROOT/scripts/bash-to-fish" "$HOME/.local/bin/hyprx-bash-to-fish"
cp -n "$ROOT"/wallpapers/* "$HOME/Pictures/Wallpapers/HyprX/" 2>/dev/null || true
main="$CFG/hypr/hyprland.lua"; mkdir -p "$(dirname "$main")"
if [[ -f "$main" ]]; then cp -a "$main" "$main.hyprx.$(date +%Y%m%d-%H%M%S).bak"; else printf '%s\n' '-- Base Hyprland Lua configuration' > "$main"; fi

sed -i '/^-- HYPRX:BEGINS/,/^-- HYPRX:ENDS/d' "$main"

cat >> "$main" <<'LUA'

-- HYPRX:BEGIN
dofile(os.getenv("HOME") .. "/.config/hypr/hyprx/keybinds.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/hyprx/autostart.lua")
-- HYPRX:END

LUA

((FISH)) && "$HOME/.local/bin/hyprx-bash-to-fish"
log 'Installed. Reload Hyprland or log out/in. Quickshell config: qs -c hyprx'
