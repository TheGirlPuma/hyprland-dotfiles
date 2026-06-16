#!/usr/bin/env bash
# Hyprland Dotfiles: Pakete installieren + Symlinks nach ~/.config
# Arch / CachyOS — nach dem Klonen: ./install.sh

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

PACKAGES=(
    # Hyprland
    hyprland hypridle hyprlock hyprpaper hyprpolkitagent
    # Bar & Launcher
    waybar rofi wlogout
    # Terminal & Dateien
    kitty dolphin
    # Desktop
    dunst libnotify polkit
    # Clipboard
    wl-clipboard cliphist
    # Audio (Waybar + Media-Keys)
    pipewire pipewire-pulse wireplumber pavucontrol playerctl
    # Netzwerk, Bluetooth, Akku (Waybar-Module)
    networkmanager bluez bluez-utils blueman upower
    # Screenshots
    grim slurp hyprshot
    # Skripte
    jq
    # Corsair (in hyprland.conf Autostart)
    ckb-next
    # Waybar-Icons
    ttf-jetbrains-mono-nerd noto-fonts-emoji
)

usage() {
    cat <<EOF
Usage: $(basename "$0") [OPTION]

  (ohne Option)   Pakete installieren + Configs verlinken
  --packages      Nur Pakete installieren
  --config        Nur Symlinks setzen (kein pacman)
  -h, --help      Diese Hilfe

Nach der Installation: hyprctl reload  (oder neu einloggen)
EOF
}

install_packages() {
    if ! command -v pacman >/dev/null 2>&1; then
        echo "Fehler: pacman nicht gefunden — dieses Skript ist für Arch/CachyOS."
        exit 1
    fi

    echo "=== Pakete installieren (${#PACKAGES[@]} Stück) ==="
    sudo pacman -Syu --needed --noconfirm "${PACKAGES[@]}"
    echo "Pakete installiert."
}

link_config() {
    local name="$1"
    local target="$REPO/$name"
    local dest="$HOME/.config/$name"

    if [[ -e "$dest" && ! -L "$dest" ]]; then
        mv "$dest" "${dest}.bak.$(date +%s)"
        echo "  Backup: ~/.config/$name"
    elif [[ -L "$dest" ]]; then
        rm -f "$dest"
    fi

    ln -sfn "$target" "$dest"
    echo "  ~/.config/$name -> $target"
}

install_configs() {
    echo "=== Configs verlinken ==="
    mkdir -p "$HOME/.config/rofi/cache"

    link_config hypr
    link_config waybar
    link_config rofi

    chmod +x "$REPO/hypr/scripts"/*.sh "$REPO/scripts"/*.sh
    echo "Skripte ausführbar gemacht."
}

MODE="${1:-all}"

case "$MODE" in
    -h|--help)
        usage
        exit 0
        ;;
    --packages)
        install_packages
        ;;
    --config)
        install_configs
        ;;
    all|"")
        install_packages
        echo ""
        install_configs
        echo ""
        echo "Fertig. Reload: hyprctl reload"
        ;;
    *)
        echo "Unbekannte Option: $MODE"
        usage
        exit 1
        ;;
esac