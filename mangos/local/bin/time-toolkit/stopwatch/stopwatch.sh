#!/usr/bin/env bash

start_time=$(date +%s)
last_blinked_hour=-1

NC='\033[0m'
BLINK='\033[5m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
GREEN='\033[0;32m'

ascii_base=$(cat <<'EOF'
███████╗████████╗ ██████╗ ██████╗ ██╗    ██╗ █████╗ ████████╗ ██████╗██╗  ██╗
██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██║    ██║██╔══██╗╚══██╔══╝██╔════╝██║  ██║
███████╗   ██║   ██║   ██║██████╔╝██║ █╗ ██║███████║   ██║   ██║     ███████║
╚════██║   ██║   ██║   ██║██╔═══╝ ██║███╗██║██╔══██║   ██║   ██║     ██╔══██║
███████║   ██║   ╚██████╔╝██║     ╚███╔███╔╝██║  ██║   ██║   ╚██████╗██║  ██║
╚══════╝   ╚═╝    ╚═════╝ ╚═╝      ╚══╝╚══╝ ╚═╝  ╚═╝   ╚═╝    ╚═════╝╚═╝  ╚═╝
EOF
)

trap "tput cnorm; echo -e '\nStopped.'; exit" INT
tput civis

ascii_lines=$(echo -e "$ascii_base" | wc -l)

blink_ascii_art() {
    for _ in {1..3}; do
        tput clear
        display_ascii "${BLINK}${GREEN}"
        sleep 0.3
        tput clear
        sleep 0.2
    done
}

display_ascii() {
    local color_prefix=$1
    IFS=$'\n'
    i=0
    for line in $(echo -e "$ascii_base"); do
        tput cup $((art_row + i)) $(( (cols - ${#line}) / 2 ))
        echo -e "${color_prefix}${line}${NC}"
        ((i++))
    done
}

while true; do
    current_time=$(date +%s)
    elapsed=$((current_time - start_time))

    hours=$((elapsed / 3600))
    minutes=$(((elapsed % 3600) / 60))
    seconds=$((elapsed % 60))
    timer=$(printf " %02d:%02d:%02d" "$hours" "$minutes" "$seconds")

    color_code=$((31 + (hours % 7)))
    COLOR="\033[0;${color_code}m"

    rows=$(tput lines)
    cols=$(tput cols)

    art_row=$(((rows - ascii_lines) / 2 - 1))
    timer_row=$((art_row + ascii_lines + 1))
    timer_col=$(((cols - ${#timer}) / 2))

    if [[ $hours -ne $last_blinked_hour ]]; then
        last_blinked_hour=$hours
        blink_ascii_art
    fi

    tput clear
    display_ascii "$PURPLE"

    tput cup "$timer_row" "$timer_col"
    echo -e "${COLOR}${timer}${NC}"

    sleep 1
done
