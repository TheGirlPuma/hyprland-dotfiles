#!/bin/bash
CHOICE=$(echo -e "🔒 Lock\n🚪 Logout\n🔄 Reboot\n⏻ Shutdown\n❌ Cancel" | \
         wofi --show dmenu --prompt "Power Menu" --width 320 --height 250)

case $CHOICE in
    "🔒 Lock") hyprlock ;;
    "🚪 Logout") hyprctl dispatch exit ;;
    "🔄 Reboot") systemctl reboot ;;
    "⏻ Shutdown") systemctl poweroff ;;
    "❌ Cancel"|*) exit 0 ;;
esac
