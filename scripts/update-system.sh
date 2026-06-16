#!/usr/bin/env bash
# Sicheres System-Update (CachyOS/Arch)
# Offizielle Repos zuerst, AUR danach mit Kurz-Check.
# Nicht mit sudo starten — pacman nutzt sudo selbst; paru läuft als User.

set -euo pipefail

if [[ $EUID -eq 0 ]]; then
    if [[ -n "${SUDO_USER:-}" && "$SUDO_USER" != root ]]; then
        exec sudo -u "$SUDO_USER" -H bash "$0" "$@"
    fi
    echo "Fehler: Bitte ohne sudo ausführen:"
    echo "  ~/.config/hypr/scripts/update-system.sh"
    echo "AUR-Pakete (paru) dürfen nicht als root installiert werden."
    exit 1
fi

echo "=== 1/3 Offizielle Repos (pacman) ==="
sudo pacman -Syu

echo ""
echo "=== 2/3 Paru selbst (aus offiziellen Repos) ==="
sudo pacman -S --needed paru

echo ""
echo "=== 3/3 AUR-Updates (mit Malware-Check) ==="
updates=$(paru -Qua 2>/dev/null | awk '{print $1}' || true)

if [[ -z "$updates" ]]; then
    echo "Keine AUR-Updates ausstehend."
    exit 0
fi

echo "Ausstehende AUR-Pakete:"
paru -Qua

suspicious=0
for pkg in $updates; do
    if paru -Gp "$pkg" 2>/dev/null | rg -qi 'atomic-lockfile|js-digest|npm install'; then
        echo "WARNUNG: Verdächtiger Eintrag in $pkg — übersprungen!"
        suspicious=1
    fi
done

if [[ $suspicious -eq 1 ]]; then
    echo "Einige Pakete wurden wegen Verdacht nicht installiert. Manuell prüfen: paru -Gp <paket>"
    exit 1
fi

read -r -p "AUR-Updates jetzt installieren? [j/N] " ans
if [[ "${ans,,}" == "j" || "${ans,,}" == "ja" ]]; then
    # paru muss als normaler User laufen (nicht root)
    paru -Sua
else
    echo "AUR-Update abgebrochen."
fi

echo "Fertig."