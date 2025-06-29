#!/bin/bash

case $1 in
    "up")
        brightnessctl set 10%+
        BRIGHTNESS=$(brightnessctl get)
        MAX_BRIGHTNESS=$(brightnessctl max)
        PERCENTAGE=$(( (BRIGHTNESS * 100) / MAX_BRIGHTNESS ))
        notify-send "Brightness" "Brightness: ${PERCENTAGE}%" -h int:value:$PERCENTAGE -h string:synchronous:brightness
        ;;
    "down")
        brightnessctl set 10%-
        BRIGHTNESS=$(brightnessctl get)
        MAX_BRIGHTNESS=$(brightnessctl max)
        PERCENTAGE=$(( (BRIGHTNESS * 100) / MAX_BRIGHTNESS ))
        notify-send "Brightness" "Brightness: ${PERCENTAGE}%" -h int:value:$PERCENTAGE -h string:synchronous:brightness
        ;;
esac
