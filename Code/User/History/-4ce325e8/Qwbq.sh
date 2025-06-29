#!/bin/bash

# File to track Waybar's current visibility state (managed by this script)
STATE_FILE="/tmp/waybar_visibility_state"

# Ensure the state file exists and is set to "visible" initially
if [[ ! -f "$STATE_FILE" ]]; then
    echo "visible" > "$STATE_FILE"
fi

# Loop indefinitely to continuously monitor window count
while true; do
    # Get the number of open Hyprland client windows
    # hyprctl clients -j returns a JSON array of windows. jq '. | length' counts them.
    # This typically does *not* include Waybar itself.
    num_windows=$(hyprctl clients -j | jq '. | length')

    CURRENT_STATE=$(cat "$STATE_FILE")

    if (( num_windows > 0 )); then
        # If windows are open and Waybar is currently marked as visible by script
        if [[ "$CURRENT_STATE" == "visible" ]]; then
            # Send SIGUSR1 to hide Waybar
            pkill -SIGUSR1 waybar
            echo "hidden" > "$STATE_FILE"
        fi
    else # num_windows == 0 (no windows open)
        # If no windows are open and Waybar is currently marked as hidden by script
        if [[ "$CURRENT_STATE" == "hidden" ]]; then
            # Send SIGUSR1 to show Waybar
            pkill -SIGUSR1 waybar
            echo "visible" > "$STATE_FILE"
        fi
    fi

    # Sleep for a short duration to prevent excessive CPU usage
    sleep 0.5
done
