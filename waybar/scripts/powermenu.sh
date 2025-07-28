#!/bin/bash

options="Logout\nReboot\nShutdown"

selected=$(echo -e $options | wofi --dmenu --width=120 --height=120 \
  --location=top_right --x=-40 --y=5 \
  --hide-scroll --no-actions \
  --insensitive --prompt="" --cache-file=/dev/null \
  --style ~/.config/wofi/style_power.css \
  --hide-search)

case $selected in
    Logout)
        hyprctl dispatch exit
        ;;
    Reboot)
        systemctl reboot
        ;;
    Shutdown)
        systemctl poweroff
        ;;
esac
