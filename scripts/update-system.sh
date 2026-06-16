#!/usr/bin/env bash
# Sicheres System-Update (CachyOS/Arch)
# Offizielle Repos zuerst, AUR danach mit Kurz-Check.

set -euo pipefail

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
    paru -Sua
else
    echo "AUR-Update abgebrochen."
fi

echo "Fertig."