#!/usr/bin/env bash
set -Eeuo pipefail
REPO="${HYPRX_REPO:-https://github.com/Gwar17/HyprX.git}"
DIR="${TMPDIR:-/tmp}/hyprx-install-$$"
trap 'rm -rf "$DIR"' EXIT
git clone --depth 1 "$REPO" "$DIR"
exec "$DIR/install.sh" "$@"
