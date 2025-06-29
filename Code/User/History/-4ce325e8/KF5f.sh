#!/bin/bash

STATE_FILE="/tmp/waybar_visibility_state"

# Initialize state file if it doesn't exist
if [[ ! -f "$STATE_FILE" ]]; then
    echo "visible" > "$STATE_FILE"
fi

# Log script start (for debugging)
echo "$(date) - Waybar autohide script started." >> /tmp/waybar_autohide_debug.log

while true; do
    # Get the ID of the currently active workspace
    # This ensures we only count windows on the workspace you are currently viewing
    ACTIVE_WORKSPACE_ID=$(hyprctl activeworkspace -j | jq -r '.id')

    # Count only mapped (visible) windows that are on the ACTIVE_WORKSPACE_ID
    # 'map(select(.workspace.id == $active_ws and .mapped == true))' filters the clients array
    # .workspace.id matches the active workspace ID
    # .mapped == true ensures the window is actually visible (not minimized/hidden)
    num_windows=$(hyprctl clients -j | jq --argjson active_ws "$ACTIVE_WORKSPACE_ID" 'map(select(.workspace.id == $active_ws and .mapped == true)) | length')

    CURRENT_STATE=$(cat "$STATE_FILE")

    # Log current state and window count (for debugging)
    echo "$(date) - On WS $ACTIVE_WORKSPACE_ID: num_windows: $num_windows, CURRENT_STATE: $CURRENT_STATE" >> /tmp/waybar_autohide_debug.log

    if (( num_windows > 0 )); then
        # If there are visible windows on the active workspace
        if [[ "$CURRENT_STATE" == "visible" ]]; then
            pkill -SIGUSR1 waybar # Hide Waybar
            echo "hidden" > "$STATE_FILE" # Update state
            echo "$(date) - Action: HIDDEN waybar" >> /tmp/waybar_autohide_debug.log
        fi
    else # num_windows == 0 (no visible windows on the active workspace)
        # If no visible windows and Waybar is currently hidden by script
        if [[ "$CURRENT_STATE" == "hidden" ]]; then
            pkill -SIGUSR1 waybar # Show Waybar
            echo "visible" > "$STATE_FILE" # Update state
            echo "$(date) - Action: SHOWN waybar" >> /tmp/waybar_autohide_debug.log
        fi
    fi

    # Sleep for a short duration to prevent excessive CPU usage
    sleep 0.5
done
