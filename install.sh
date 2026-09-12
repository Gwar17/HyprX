#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
BIN="$HOME/.local/bin"
export PATH="$BIN:$PATH"
STAMP="$(date +%Y%m%d-%H%M%S)"
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
for cmd in hyprland qs kitty dolphin awww; do
  command -v "$cmd" >/dev/null 2>&1 || die "Missing $cmd. Run bootstrap/install-hyprland.sh first."
done

BACKUP="$HOME/.local/state/hyprx/backups/$STAMP"
log "Backing up managed configuration to $BACKUP"
mkdir -p "$BACKUP" "$BIN" "$HOME/Pictures/Wallpapers"
for path in \
  "$CFG/hypr/hyprland.lua" \
  "$CFG/hypr/hyprx" \
  "$CFG/quickshell/hyprx" \
  "$CFG/kitty/kitty.conf" \
  "$CFG/rofi/config.rasi"; do
  [[ -e "$path" ]] && cp -a --parents "$path" "$BACKUP/" || true
done

log 'Installing HyprX Lua and Quickshell layout'
rm -rf "$CFG/hypr/hyprx" "$CFG/quickshell/hyprx"
mkdir -p "$CFG/hypr/hyprx" "$CFG/quickshell" "$CFG/hyprx/themes"
cp -a "$ROOT/hyprx/." "$CFG/hypr/hyprx/"
cp -a "$ROOT/quickshell/hyprx" "$CFG/quickshell/hyprx"

main="$CFG/hypr/hyprland.lua"
mkdir -p "$(dirname "$main")"
if [[ ! -f "$main" ]]; then
  install -m644 "$ROOT/hypr/hyprland.lua" "$main"
else
  # Preserve the existing Lua configuration, while disabling the known stock bindings that HyprX replaces.
  sed -i '/hl\.bind(mainMod .. " + Q", hl\.dsp\.exec_cmd(terminal))/s/^/-- HYPRX-DISABLED: /' "$main"
  sed -i 's/^-- closeWindowBind:set_enabled(false)$/closeWindowBind:set_enabled(false)/' "$main"
  # HyprX owns only this guarded block in an existing Lua configuration.
  sed -i '/-- HYPRX:BEGIN/,/-- HYPRX:END/d' "$main"
  cat >> "$main" <<'LUA'

-- HYPRX:BEGIN
dofile(os.getenv("HOME") .. "/.config/hypr/hyprx/colors.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/hyprx/keybinds.lua")
dofile(os.getenv("HOME") .. "/.config/hypr/hyprx/autostart.lua")
-- HYPRX:END
LUA
fi

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

if [[ ! -f "$CFG/hyprx/current-theme.txt" ]]; then
  printf '%s\n' Catppuccin > "$CFG/hyprx/current-theme.txt"
fi
active="$(cat "$CFG/hyprx/current-theme.txt" 2>/dev/null || printf Catppuccin)"
[[ -d "$CFG/hyprx/themes/$active" ]] || active=Catppuccin
"$BIN/hyprx-theme" "$active"

((FISH)) && "$BIN/hyprx-shell" fish
log 'HyprX installation complete.'
log 'Log out/in or reboot to start the HyprX session.'
