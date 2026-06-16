#!/usr/bin/env bash
# Aktuellen virtuellen Desktop schließen (wie Strg+Win+F4 unter Windows).

ws_id=$(hyprctl activeworkspace -j | jq -r '.id')
window_count=$(hyprctl activeworkspace -j | jq -r '.windows')

if [[ "$window_count" -gt 0 ]]; then
    hyprctl clients -j | jq -r ".[] | select(.workspace.id == $ws_id) | .address" | while read -r addr; do
        hyprctl dispatch closewindow "address:$addr"
    done
fi

hyprctl dispatch workspace m-1