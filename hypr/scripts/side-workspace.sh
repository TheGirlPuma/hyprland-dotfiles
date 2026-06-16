#!/usr/bin/env bash
# Workspace auf dem Nebenmonitor wechseln, Fokus bleibt auf dem Hauptmonitor.

SIDE_MON="HDMI-A-1"
WS="$1"

if [[ -z "$WS" ]]; then
    notify-send "Hyprland" "Kein Workspace angegeben." 2>/dev/null
    exit 1
fi

focused_name=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
focused_id=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .id')

hyprctl dispatch focusmonitor "$SIDE_MON"
hyprctl dispatch workspace "$WS"

if [[ "$focused_name" != "$SIDE_MON" ]]; then
    hyprctl dispatch focusmonitor "$focused_id"
fi