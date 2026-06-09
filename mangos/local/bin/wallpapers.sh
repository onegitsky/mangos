#!/usr/bin/env bash

THUMB_DIR="$HOME/.cache/wall-thumbs"
mkdir -p "$THUMB_DIR"

generate_thumb() {
    local img="$1"

    local hash
    hash=$(printf '%s' "$img" | md5sum | cut -d' ' -f1)

    local thumb="$THUMB_DIR/${hash}.png"

    if [[ ! -f "$thumb" || "$img" -nt "$thumb" ]]; then
        magick "$img" \
            -thumbnail 128x128^ \
            -gravity center \
            -extent 128x128 \
            "$thumb"
    fi

    printf '%s\n' "$thumb"
}

WALL_DIR="$HOME/Pictures/Wallpapers/swww/"

mapfile -t WALLPAPERS < <(
    find "$WALL_DIR" \
        -type f \
        \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) |
    sort
)

rofi_input=""
for ((i=0; i<${#WALLPAPERS[@]}; i++)); do
    file="${WALLPAPERS[$i]}"
    filename=$(basename "$file")

    thumb=$(generate_thumb "$file")

    entry="$filename\0icon\x1f$thumb"

    if [ $i -eq 0 ]; then
        rofi_input="$entry"
    else
        rofi_input+=$'\n'"$entry"
    fi
done

selected=$(
    printf '%b\n' "$rofi_input" |
    rofi -dmenu \
         -show-icons \
         -i \
         -p "Wallpaper" \
         -theme ~/.config/rofi/perfect-blue/wallpaper.rasi
)

[ -z "$selected" ] && exit 0

wallpaper="$WALL_DIR/$selected"

# Set wallpaper with animation
awww img "$wallpaper" \
    --transition-type random \
    --transition-duration 1 \
    --transition-fps 60

# Generate pywal16 colors
wal -i "$wallpaper"

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

notify-send \
    "Theme Changed" \
    "$selected" \
    -a "Theme Manager"
