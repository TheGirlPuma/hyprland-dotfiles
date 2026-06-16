#!/usr/bin/env bash
# Aktuellen Desktop auf den anderen Monitor verschieben.

current_mon=$(hyprctl activeworkspace -j | jq -r '.monitor')

if [[ "$current_mon" == "DP-1" ]]; then
    hyprctl dispatch movecurrentworkspacetomonitor HDMI-A-1
    notify-send "Desktop verschoben" "Jetzt auf Nebenmonitor (links)" 2>/dev/null
else
    hyprctl dispatch movecurrentworkspacetomonitor DP-1
    notify-send "Desktop verschoben" "Jetzt auf Hauptmonitor (rechts)" 2>/dev/null
fi