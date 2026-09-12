#!/usr/bin/env bash
set -Eeuo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
log(){ printf '\033[1;36m[HyprX installer]\033[0m %s\n' "$*"; }
die(){ printf 'HyprX: %s\n' "$*" >&2; exit 1; }

[[ $EUID -ne 0 ]] || die 'Run this installer as your normal user, not root.'
command -v pacman >/dev/null 2>&1 || die 'pacman was not found. HyprX currently targets pacman-based systems.'

log 'Refreshing the system and package database'
sudo pacman -Syu --noconfirm

if ! command -v paru >/dev/null 2>&1; then
  log 'Installing paru'
  if ! sudo pacman -S --needed --noconfirm paru; then
    sudo pacman -S --needed --noconfirm base-devel git
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT
    git clone --depth 1 https://aur.archlinux.org/paru.git "$tmp/paru"
    (cd "$tmp/paru" && makepkg -si --noconfirm)
    rm -rf "$tmp"
    trap - EXIT
  fi
fi

mapfile -t repo_pkgs < <(grep -Ev '^\s*(#|$)' "$ROOT/bootstrap/packages.repo")
mapfile -t aur_pkgs  < <(grep -Ev '^\s*(#|$)' "$ROOT/bootstrap/packages.aur")

log 'Installing Hyprland and desktop applications'
sudo pacman -S --needed --noconfirm "${repo_pkgs[@]}"

if ((${#aur_pkgs[@]})); then
  log 'Installing AUR applications'
  paru -S --needed --noconfirm "${aur_pkgs[@]}"
fi

log 'Enabling desktop services'
sudo systemctl enable NetworkManager.service bluetooth.service sddm.service

log 'Installing the HyprX SDDM theme'
sudo install -d /usr/share/sddm/themes /etc/sddm.conf.d
sudo rm -rf /usr/share/sddm/themes/hyprx
sudo cp -a "$ROOT/greeter/hyprx" /usr/share/sddm/themes/hyprx
sudo tee /etc/sddm.conf.d/hyprx.conf >/dev/null <<'SDDM'
[Theme]
Current=hyprx
SDDM

log 'Installing the HyprX desktop layout'
"$ROOT/install.sh"

printf '\nShell choice (Bash is the default; Fish can be selected now or later):\n  1) Bash\n  2) Fish\n'
read -r -p 'Select [1]: ' shell_choice
case "${shell_choice:-1}" in
  2|fish|Fish) "$HOME/.local/bin/hyprx-shell" fish ;;
  *) "$HOME/.local/bin/hyprx-shell" bash ;;
esac

log 'Installation complete. Reboot, then choose Hyprland in SDDM.'
