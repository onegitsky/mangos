#!/usr/bin/env bash

WALL_DIR="$HOME/Pictures/Wallpapers/swww"
STATE_FILE="$HOME/.cache/current-wallpaper"

mapfile -t WALLPAPERS < <(
    find "$WALL_DIR" \
        -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) |
    sort
)

[ ${#WALLPAPERS[@]} -eq 0 ] && exit 1

# First run
if [[ ! -f "$STATE_FILE" ]]; then
    next="${WALLPAPERS[0]}"
else
    current=$(cat "$STATE_FILE")

    next="${WALLPAPERS[0]}"

    for i in "${!WALLPAPERS[@]}"; do
        if [[ "${WALLPAPERS[$i]}" == "$current" ]]; then
            next="${WALLPAPERS[$(((i + 1) % ${#WALLPAPERS[@]}))]}"
            break
        fi
    done
fi

printf '%s\n' "$next" > "$STATE_FILE"

# Set wallpaper
awww img "$next" \
    --transition-type random \
    --transition-duration 1 \
    --transition-fps 60

# Generate pywal colors
wal -i "$next"

# Update Vesktop theme
cp ~/.cache/wal/system24.theme.css \
   ~/.config/vesktop/themes/system24.theme.css

# Get wal background color
BG=$(grep 'set \$background' ~/.cache/wal/colors-sway | awk '{print $3}')
BG=${BG#\#}

# Append alpha
DROP="0x${BG}77"

sed -i "s/^dropcolor=.*/dropcolor=${DROP}/" ~/.config/mango/config.conf

mmsg -s -d reload_config

# Reload applications
pkill -SIGUSR2 waybar

swaync-client --reload-css

killall -SIGUSR1 foot

pkill swayosd-server
swayosd-server >/dev/null 2>&1 &
