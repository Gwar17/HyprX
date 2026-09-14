#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
log(){ printf '\033[1;36m[HyprX installer]\033[0m %s\n' "$*"; }
die(){ printf 'HyprX: %s\n' "$*" >&2; exit 1; }

[[ $EUID -ne 0 ]] || die 'Run this installer as your normal user, not root.'
command -v pacman >/dev/null 2>&1 || die 'pacman was not found. HyprX targets Arch/pacman systems.'

log 'Updating the system'
sudo pacman -Syu --noconfirm

mapfile -t repo_pkgs < <(grep -Ev '^\s*(#|$)' "$ROOT/bootstrap/packages.repo")
((${#repo_pkgs[@]})) || die 'bootstrap/packages.repo is empty.'

log 'Installing the current stable HyprX desktop stack'
sudo pacman -S --needed --noconfirm "${repo_pkgs[@]}"

command -v uwsm >/dev/null 2>&1 || die 'UWSM installation failed.'
[[ -f /usr/share/wayland-sessions/hyprland-uwsm.desktop ]] || die 'Hyprland UWSM session entry is missing.'

log 'Enabling system services'
sudo systemctl enable NetworkManager.service bluetooth.service sddm.service

log 'Installing the HyprX SDDM theme'
sudo install -d /usr/share/sddm/themes /etc/sddm.conf.d
sudo rm -rf /usr/share/sddm/themes/hyprx
sudo cp -a "$ROOT/greeter/hyprx" /usr/share/sddm/themes/hyprx
sudo tee /etc/sddm.conf.d/hyprx.conf >/dev/null <<'SDDM'
[Theme]
Current=hyprx
SDDM

log 'Installing the HyprX desktop'
"$ROOT/install.sh"

printf '\nShell choice (Bash is the default; Fish can be selected now or later):\n  1) Bash\n  2) Fish\n'
read -r -p 'Select [1]: ' shell_choice
case "${shell_choice:-1}" in
  2|fish|Fish) "$HOME/.local/bin/hyprx-shell" fish ;;
  *) "$HOME/.local/bin/hyprx-shell" bash ;;
esac

log 'Installation complete.'
log 'Reboot and choose Hyprland (uwsm-managed) in SDDM.'
