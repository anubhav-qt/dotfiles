#!/bin/bash

get_volume_info() {
    # Get volume as decimal and convert to percentage
    VOLUME_RAW=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}')
    # Convert to percentage using awk
    VOLUME_PERCENT=$(echo "$VOLUME_RAW" | awk '{printf "%.0f", $1*100}')
    echo "$VOLUME_PERCENT"
}

case $1 in
    "up")
        # Get current volume percentage
        CURRENT_VOL=$(get_volume_info)
        
        # Check if we're already at max
        if [ "$CURRENT_VOL" -ge 100 ]; then
            notify-send "Volume" "Volume already at maximum (100%)" -h string:synchronous:volume
        else
            # Increase volume by 5%
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
            VOLUME=$(get_volume_info)
            # Cap display at 100% but allow the actual increase
            if [ "$VOLUME" -gt 100 ]; then
                VOLUME=100
            fi
            notify-send "Volume" "Volume: ${VOLUME}%" -h int:value:$VOLUME -h string:synchronous:volume
        fi
        ;;
    "down")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
        VOLUME=$(get_volume_info)
        notify-send "Volume" "Volume: ${VOLUME}%" -h int:value:$VOLUME -h string:synchronous:volume
        ;;
    "mute")
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o "MUTED" || echo "")
        if [ "$MUTED" = "MUTED" ]; then
            notify-send "Volume" "Audio Muted" -h string:synchronous:volume
        else
            VOLUME=$(get_volume_info)
            notify-send "Volume" "Audio Unmuted: ${VOLUME}%" -h int:value:$VOLUME -h string:synchronous:volume
        fi
        ;;
esac
