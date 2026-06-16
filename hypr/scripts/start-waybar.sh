#!/usr/bin/env bash
# Waybar exakt einmal starten (Lock gegen Doppel-Start bei exec + exec-once).

LOCK_FILE="/tmp/waybar-start.lock"
exec 9>"$LOCK_FILE"
flock -n 9 || exit 0

pkill -x waybar 2>/dev/null
for _ in {1..30}; do
    pgrep -x waybar >/dev/null || break
    sleep 0.05
done

exec waybar