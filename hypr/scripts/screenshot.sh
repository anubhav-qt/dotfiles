#!/bin/bash

# Generate single timestamp for consistency
TIMESTAMP=$(date +'%Y-%m-%d-%H%M%S')
FILENAME="$HOME/Pictures/${TIMESTAMP}.png"

case $1 in
    "full")
        grim "$FILENAME" && wl-copy < "$FILENAME"
        if [ $? -eq 0 ]; then
            notify-send "Screenshot" "Full screen saved and copied to clipboard" -i "$FILENAME"
        else
            notify-send "Screenshot" "Failed to take screenshot" -u critical
        fi
        ;;
    "region")
        grim -g "$(slurp)" "$FILENAME"
        if [ $? -eq 0 ]; then
            wl-copy < "$FILENAME"
            notify-send "Screenshot" "Region saved and copied to clipboard" -i "$FILENAME"
        else
            notify-send "Screenshot" "Screenshot cancelled or failed" -u normal
        fi
        ;;
    "window")
        WINDOW=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')
        grim -g "$WINDOW" "$FILENAME" && wl-copy < "$FILENAME"
        if [ $? -eq 0 ]; then
            notify-send "Screenshot" "Window saved and copied to clipboard" -i "$FILENAME"
        else
            notify-send "Screenshot" "Failed to capture window" -u critical
        fi
        ;;
esac
