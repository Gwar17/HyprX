#!/usr/bin/env bash
set -Eeuo pipefail
REPO="${HYPRX_REPO:-https://github.com/Gwar17/HyprX.git}"
DIR="${TMPDIR:-/tmp}/hyprx-install-$$"
trap 'rm -rf "$DIR"' EXIT
command -v git >/dev/null 2>&1 || sudo pacman -S --needed --noconfirm git
git clone --depth 1 "$REPO" "$DIR"
exec "$DIR/bootstrap/install-hyprland.sh" "$@"
