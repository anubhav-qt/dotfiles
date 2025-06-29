#!/bin/bash

# Get the width of the primary monitor
SCREEN_WIDTH=$(hyprctl monitors -j | jq '.[] | select(.focused) | .width')
# Set a threshold for the right edge
EDGE_THRESHOLD=5
# The width of the visible part of your hidden bar
VISIBLE_PART=2

# Calculate coordinates for showing and hiding the bar
SHOW_AT_X=$((SCREEN_WIDTH - EDGE_THRESHOLD))
HIDE_AT_X=$((SCREEN_WIDTH - VISIBLE_PART - 50)) # Hide when cursor is 50px away from the visible part

# Initially hide the bar
pkill -SIGUSR2 waybar
bar_hidden=true

while true; do
    # Get cursor's X position
    read X < <(hyprctl cursorpos -j | jq '.x')

    # Scenario 1: Bar is hidden and cursor is at the far right edge
    if [ "$bar_hidden" = true ] && [ "$X" -ge "$SHOW_AT_X" ]; then
        pkill -SIGUSR1 waybar # Send signal to show Waybar
        bar_hidden=false
        # Wait until the cursor moves away from the edge before checking again
        while [ "$X" -ge "$HIDE_AT_X" ]; do
            sleep 0.2
            read X < <(hyprctl cursorpos -j | jq '.x')
        done
    # Scenario 2: Bar is visible and cursor has moved away from it
    elif [ "$bar_hidden" = false ] && [ "$X" -lt "$HIDE_AT_X" ]; then
        pkill -SIGUSR2 waybar # Send signal to hide Waybar
        bar_hidden=true
    fi

    sleep 0.2
done
