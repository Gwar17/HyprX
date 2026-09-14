#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
BIN="$HOME/.local/bin"
STAMP="$(date +%Y%m%d-%H%M%S)"
export PATH="$BIN:$PATH"

FISH=0
for x in "$@"; do
  case "$x" in
    --fish) FISH=1 ;;
    -h|--help) echo 'Usage: ./install.sh [--fish]'; exit 0 ;;
    *) echo "Unknown option: $x" >&2; exit 2 ;;
  esac
done

log(){ printf '\033[1;36m[HyprX]\033[0m %s\n' "$*"; }
die(){ printf 'HyprX: %s\n' "$*" >&2; exit 1; }

[[ $EUID -ne 0 ]] || die 'Run as your normal user, not root.'
for cmd in hyprland uwsm qs kitty dolphin awww systemctl; do
  command -v "$cmd" >/dev/null 2>&1 || die "Missing $cmd. Run bootstrap/install-hyprland.sh first."
done

BACKUP="$HOME/.local/state/hyprx/backups/$STAMP"
log "Backing up existing configuration to $BACKUP"
mkdir -p "$BACKUP" "$BIN" "$HOME/Pictures/Wallpapers"
for path in \
  "$CFG/hypr/hyprland.lua" \
  "$CFG/hypr/hyprland.conf" \
  "$CFG/hypr/hyprx" \
  "$CFG/hypr/modules" \
  "$CFG/quickshell/hyprx" \
  "$CFG/kitty/kitty.conf" \
  "$CFG/rofi/config.rasi" \
  "$CFG/uwsm/env" \
  "$CFG/uwsm/env-hyprland" \
  "$CFG/systemd/user/hyprx-awww.service" \
  "$CFG/systemd/user/hyprx-quickshell.service" \
  "$CFG/systemd/user/hyprx-wallpaper.service"; do
  [[ -e "$path" ]] && cp -a --parents "$path" "$BACKUP/" || true
done

log 'Installing the HyprX Lua configuration and Quickshell layout'
rm -rf "$CFG/hypr/hyprx" "$CFG/hypr/modules" "$CFG/quickshell/hyprx"
rm -f "$CFG/hypr/hyprland.conf"
mkdir -p "$CFG/hypr" "$CFG/hypr/modules" "$CFG/quickshell" "$CFG/hyprx/themes" "$CFG/uwsm" "$CFG/systemd/user"
install -m644 "$ROOT/hypr/hyprland.lua" "$CFG/hypr/hyprland.lua"
cp -a "$ROOT/hypr/modules/." "$CFG/hypr/modules/"
cp -a "$ROOT/quickshell/hyprx" "$CFG/quickshell/hyprx"

log 'Installing UWSM-owned environment settings'
cat > "$CFG/uwsm/env" <<'UWSM_ENV'
export XCURSOR_SIZE=24
export QT_QPA_PLATFORMTHEME=qt6ct
UWSM_ENV
cat > "$CFG/uwsm/env-hyprland" <<'UWSM_HYPR'
export HYPRCURSOR_SIZE=24
UWSM_HYPR

log 'Installing themes and wallpaper collections'
rm -rf "$CFG/hyprx/themes"
mkdir -p "$CFG/hyprx/themes"
cp -a "$ROOT/theme/themes/." "$CFG/hyprx/themes/"
for d in "$ROOT"/wallpapers/*; do
  [[ -d "$d" ]] || continue
  name="$(basename "$d")"
  mkdir -p "$HOME/Pictures/Wallpapers/$name"
  cp -an "$d/." "$HOME/Pictures/Wallpapers/$name/"
done

log 'Installing commands and application integration'
for script in hyprx-theme hyprx-wallpaper hyprx-sync-theme hyprx-restore-wallpaper bash-to-fish hyprx-shell hyprx-surface; do
  install -m755 "$ROOT/scripts/$script" "$BIN/$script"
done
mkdir -p "$CFG/kitty" "$CFG/rofi"
install -m644 "$ROOT/apps/kitty/kitty.conf" "$CFG/kitty/kitty.conf"
install -m644 "$ROOT/apps/rofi/config.rasi" "$CFG/rofi/config.rasi"
[[ -f "$CFG/kitty/hyprx-surface.conf" ]] || "$BIN/hyprx-surface" minimal

log 'Installing systemd user services for graphical-session ownership'
install -m644 "$ROOT/systemd/user/hyprx-awww.service" "$CFG/systemd/user/hyprx-awww.service"
install -m644 "$ROOT/systemd/user/hyprx-quickshell.service" "$CFG/systemd/user/hyprx-quickshell.service"
install -m644 "$ROOT/systemd/user/hyprx-wallpaper.service" "$CFG/systemd/user/hyprx-wallpaper.service"
systemctl --user daemon-reload
systemctl --user enable hyprpolkitagent.service hyprx-awww.service hyprx-quickshell.service hyprx-wallpaper.service

if [[ ! -f "$CFG/hyprx/current-theme.txt" ]]; then
  printf '%s\n' Catppuccin > "$CFG/hyprx/current-theme.txt"
fi
active="$(cat "$CFG/hyprx/current-theme.txt" 2>/dev/null || printf Catppuccin)"
[[ -d "$CFG/hyprx/themes/$active" ]] || active=Catppuccin
"$BIN/hyprx-theme" "$active"

((FISH)) && "$BIN/hyprx-shell" fish
log 'HyprX installation complete.'
