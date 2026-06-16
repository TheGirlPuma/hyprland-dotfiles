#!/usr/bin/env bash

NOTE_CLASS="shortcuts-sticky"
NOTE_FILE="$HOME/.config/hypr/shortcuts-sticky.txt"
NOTE_W=440
NOTE_H=580
NOTE_Y=54
NOTE_MARGIN=16

# Oben rechts auf DP-1, unter dem Hilfe-Icon in der Waybar
read -r mon_x mon_w <<< "$(hyprctl monitors -j | jq -r '.[] | select(.name == "DP-1") | "\(.x) \(.width)"')"
NOTE_X=$((mon_x + mon_w - NOTE_W - NOTE_MARGIN))

# Erneut öffnen = schließen
pid=$(hyprctl clients -j | jq -r --arg c "$NOTE_CLASS" '.[] | select(.class == $c) | .pid' | head -1)
if [[ -n "$pid" && "$pid" != "null" ]]; then
    kill "$pid" 2>/dev/null
    exit 0
fi

kitty --class "$NOTE_CLASS" \
    --title "Shortcuts" \
    -o initial_window_width="$NOTE_W" \
    -o initial_window_height="$NOTE_H" \
    -o font_size=11 \
    -o window_padding_width=16 \
    -o shell=/bin/sh \
    -o shell_integration=disabled \
    -o hide_window_decorations=no \
    /bin/sh -c "cat '$NOTE_FILE'; exec sleep infinity" &

# Position nach dem Start setzen (oben rechts, nicht mittig)
(
    sleep 0.35
    addr=$(hyprctl clients -j | jq -r --arg c "$NOTE_CLASS" '.[] | select(.class == $c) | .address' | head -1)
    if [[ -n "$addr" && "$addr" != "null" ]]; then
        hyprctl dispatch focuswindow "address:$addr"
        hyprctl dispatch moveactive exact "$NOTE_X" "$NOTE_Y"
    fi
) &