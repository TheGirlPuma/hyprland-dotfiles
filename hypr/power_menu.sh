#!/bin/bash
option=$(echo -e "󰍃  Logout\n󰜉  Reboot\n⏻  Shutdown\n󰤄  Suspend\n󰒲  Lock\n✕  Cancel" | wofi --show dmenu --width=300 --height=280 --prompt="Power Menu")

case "$option" in
    *"Logout") hyprctl dispatch exit ;;
    *"Reboot") systemctl reboot ;;
    *"Shutdown") systemctl poweroff ;;
    *"Suspend") systemctl suspend ;;
    *"Lock") hyprlock ;;
    *) exit 0 ;;
esac
