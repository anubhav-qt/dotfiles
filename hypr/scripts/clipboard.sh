#!/bin/bash

# Get clipboard selection and copy it
SELECTED=$(cliphist list | wofi --dmenu --prompt "Clipboard History")

if [ -n "$SELECTED" ]; then
    # Decode and copy to clipboard
    echo "$SELECTED" | cliphist decode | wl-copy
    
    # Small delay to ensure clipboard is updated
    sleep 0.1
    
    # Auto-paste using wtype (simulates Ctrl+V)
    wtype -M ctrl v
fi
