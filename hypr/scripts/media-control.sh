#!/bin/bash

case "$1" in
    vol-up)
        amixer -c 4 set PCM 5%+ unmute >/dev/null 2>&1
        amixer -c 5 set PCM 5%+ unmute >/dev/null 2>&1
        wpctl set-volume @DEFAULT_SINK@ 5%+
        notify-send "♪ ▲" "+5%" -t 700
        ;;
    vol-down)
        amixer -c 4 set PCM 5%- unmute >/dev/null 2>&1
        amixer -c 5 set PCM 5%- unmute >/dev/null 2>&1
        wpctl set-volume @DEFAULT_SINK@ 5%-
        notify-send "♪ ▼" "-5%" -t 700
        ;;
    mute)
        amixer -c 4 set PCM toggle >/dev/null 2>&1
        amixer -c 5 set PCM toggle >/dev/null 2>&1
        wpctl set-mute @DEFAULT_SINK@ toggle
        notify-send "🔇 Mute" -t 800
        ;;
    play-pause)
        playerctl play-pause
        notify-send "⏯" "Play / Pause" -t 600
        ;;
    next)
        playerctl next
        notify-send "⏭" "Nächster Titel" -t 600
        ;;
    prev)
        playerctl previous
        notify-send "⏮" "Vorheriger Titel" -t 600
        ;;
    stop)
        playerctl stop
        notify-send "⏹" "Gestoppt" -t 600
        ;;
esac
