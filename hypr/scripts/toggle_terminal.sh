#!/bin/bash

# Check if dropdown terminal exists
if hyprctl clients | grep -q "kitty-dropdown"; then
    # If it exists, toggle its visibility
    hyprctl dispatch togglespecialworkspace dropdown
else
    # If it doesn't exist, create it
    kitty --class=kitty-dropdown &
    sleep 0.1
    hyprctl dispatch togglespecialworkspace dropdown
fi
