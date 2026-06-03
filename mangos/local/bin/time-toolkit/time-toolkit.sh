#!/usr/bin/env bash

# Path setup
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ALARM_SCRIPT="$SCRIPT_DIR/alarm/alarm.sh"
STOPWATCH_SCRIPT="$SCRIPT_DIR/stopwatch/stopwatch.sh"

# ANSI colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# Strip ANSI codes for length calculation
strip_ansi() {
    echo -e "$1" | sed -E 's/\x1B\[[0-9;]*[mK]//g'
}

# Print colored text centered
print_centered() {
    local color_text="$1"
    local plain_text=$(strip_ansi "$color_text")
    local terminal_width=$(tput cols)
    local text_width=${#plain_text}
    local padding=$(( (terminal_width - text_width) / 2 ))

    printf "%*s" "$padding" ""
    echo -e "$color_text"
}

function main_menu() {
    while true; do
        clear
        local rows=$(tput lines)
        local vertical_padding=$(( (rows - 8) / 2 ))

        for ((i = 0; i < vertical_padding; i++)); do
            echo ""
        done

        print_centered "${CYAN}====== Time Toolkit ======${RESET}"
        print_centered "${YELLOW}1)${RESET} Alarm"
        print_centered "${YELLOW}2)${RESET} Stopwatch"
        print_centered "${YELLOW}3)${RESET} Exit"
        print_centered "${CYAN}==========================${RESET}"
        echo ""

        # Prompt with centered input
        local prompt="Select an option [1-3]: "
        local prompt_padding=$(( ($(tput cols) - ${#prompt}) / 2 ))
        read -p "$(printf '%*s' "$prompt_padding" '')$prompt" choice

        case "$choice" in
            1)
                bash "$ALARM_SCRIPT"
                ;;
            2)
                bash "$STOPWATCH_SCRIPT"
                ;;
            3)
                print_centered "${GREEN}Goodbye!${RESET}"
                exit 0
                ;;
            *)
                print_centered "${RED}Invalid option. Try again.${RESET}"
                sleep 1
                ;;
        esac
    done
}

main_menu

