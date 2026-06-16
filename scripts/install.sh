#!/usr/bin/env bash
# Hyprland Dotfiles installieren — Symlinks nach ~/.config

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "Installing Hyprland dotfiles from $REPO ..."

mkdir -p "$HOME/.config"

link_config() {
    local name="$1"
    local target="$REPO/$name"
    local dest="$HOME/.config/$name"

    if [[ -e "$dest" && ! -L "$dest" ]]; then
        mv "$dest" "${dest}.bak.$(date +%s)"
        echo "  Backed up existing ~/.config/$name"
    elif [[ -L "$dest" ]]; then
        rm -f "$dest"
    fi

    ln -sfn "$target" "$dest"
    echo "  Linked ~/.config/$name -> $target"
}

link_config hypr
link_config waybar
link_config rofi

chmod +x "$REPO/hypr/scripts"/*.sh

echo "Done. Reload with: hyprctl reload"