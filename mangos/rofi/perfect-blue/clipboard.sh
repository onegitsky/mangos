#!/usr/bin/env bash

selection=$(
    {
        echo "󰆴 Clear History"
        cliphist list | sed -E 's/\[\[ binary data .* \]\]/󰋩 Image/'
    } | rofi -dmenu -i -p "Clipboard" \
        -theme ~/.config/rofi/perfect-blue/clipboard.rasi
)

[ -z "$selection" ] && exit 0

if [[ "$selection" == "󰆴 Clear History" ]]; then
    cliphist wipe
    notify-send "Clipboard" "History cleared"
    exit 0
fi

cliphist decode <<< "$selection" | wl-copy
