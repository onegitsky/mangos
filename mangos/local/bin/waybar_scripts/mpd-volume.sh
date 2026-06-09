#!/bin/bash

STEP=0.05

case "$1" in
    up)
        playerctl -p mpd volume ${STEP}+
        ;;
    down)
        playerctl -p mpd volume ${STEP}-
        ;;
esac

VOL=$(playerctl -p mpd volume)
PERCENT=$(awk "BEGIN { printf \"%d\", $VOL * 100 }")

swayosd-client \
    --monitor "DP-1" \
    --custom-progress "$VOL" \
    --custom-progress-text "${PERCENT}%"
