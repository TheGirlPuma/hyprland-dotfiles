#!/usr/bin/env bash
# Hyprland Dotfiles installieren — Symlinks nach ~/.config

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Installing Hyprland dotfiles from $REPO ..."

mkdir -p "$HOME/.config"

ln -sfn "$REPO/hypr" "$HOME/.config/hypr"
ln -sfn "$REPO/waybar" "$HOME/.config/waybar"
ln -sfn "$REPO/rofi" "$HOME/.config/rofi"

chmod +x "$REPO/hypr/scripts"/*.sh

echo "Done. Reload with: hyprctl reload"