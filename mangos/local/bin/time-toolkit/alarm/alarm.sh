#!/usr/bin/env bash

RED='\033[0;31m'
BRED='\033[0;91m'
GREEN='\033[0;32m'
BGREEN='\033[0;92m'
YELLOW='\033[1;33m'
NC='\033[0m'
WHITE='\033[37m'

ALARM_GAIN=-15
DEFAULT_ALARM_FILE="$HOME/.local/bin/time-toolkit/alarm/tones/alarm.mp3"
ALARM_FILE="${ALARM_FILE:-$DEFAULT_ALARM_FILE}"
EXIT_SUCCESS=0
EXIT_INVALID_INPUT=1
EXIT_INTERRUPTED=4

parse_time() {
    local input=$1 total_seconds=0
    local value unit

    input=$(echo "$input" | tr -s ' ' | xargs)

    [[ -z $input || ! $input =~ ^([0-9]+[hms](\ *[0-9]+[hms])?)+$ ]] && return 1

    while read -r part; do
        if [[ $part =~ ^([0-9]+)([hms])$ ]]; then
            value=${BASH_REMATCH[1]}
            unit=${BASH_REMATCH[2]}
            case $unit in
                h) ((total_seconds += value * 3600)) ;;
                m) ((total_seconds += value * 60)) ;;
                s) ((total_seconds += value)) ;;
            esac
        else
            return 1
        fi
    done < <(echo "$input" | tr ' ' '\n')

    ((total_seconds > 0)) || return 1
    echo "$total_seconds"
}

get_alarm_time() {
    while :; do
        clear
        printf " \n ${RED}󰀠 ${WHITE}Set Alarm Time (e.g. 1h, 45m, 30s) ${RED}${WHITE}  "
        read -r alarm_time
        total_seconds=$(parse_time "$alarm_time" 2>/dev/null) && break
        echo -e "${RED}Invalid input: $alarm_time${NC}"
        sleep 0.3
    done
}

cleanup() {
    stty sane
    clear
    printf "\n${RED}  Alarm interrupted by user.${NC}\n"
    pkill -f "mplayer.*$ALARM_FILE" 2>/dev/null
    sleep 1
    exit $EXIT_INTERRUPTED
}

trap cleanup SIGINT

usage() {
    echo -e "Usage: $0 [-t time] [-f alarm_file]\n" \
            "  -t time       Set alarm time (e.g., '1h 30m', '45m', '30s')\n" \
            "  -f alarm_file Specify custom alarm sound file (default: $DEFAULT_ALARM_FILE)\n" \
            "  -h            Show this help message"
    exit $EXIT_INVALID_INPUT
}

while getopts "t:f:h" opt; do
    case $opt in
        t) alarm_time=$OPTARG ;;
        f) ALARM_FILE=$OPTARG ;;
        h) usage ;;
        *) usage ;;
    esac
done

if [[ -z $alarm_time ]] || ! total_seconds=$(parse_time "$alarm_time" 2>/dev/null); then
    get_alarm_time
fi

clear
echo -e " \n ${GREEN}󰀠 ${WHITE}Alarm Set for $alarm_time ($total_seconds seconds)${NC}\n"

stty -echo -icanon time 0 min 0

while ((total_seconds > 0)); do
    h=$((total_seconds / 3600))
    m=$(( (total_seconds % 3600) / 60))
    s=$((total_seconds % 60))
    time_display=$(
        ((h > 0)) && echo -n "${h}h "
        ((m > 0)) && echo -n "${m}m "
        echo "${s}s"
    )

    printf "\r${BRED} 󱞪 Time remaining: ${WHITE}%-20s${NC}" "$time_display"
    sleep 1
    ((total_seconds--))

    read -t 0.1 -n 1 key && [[ $key =~ [Qq] ]] && {
        clear
        echo -e "\n${RED}  Alarm interrupted by user.${NC}"
        sleep 1
        stty sane
        exit $EXIT_SUCCESS
    }
done

stty sane
clear
echo -e "${YELLOW} 󰹱 Alarm going off,${GREEN} playing: ${NC}$(basename "$ALARM_FILE")"
mplayer -af volume=$ALARM_GAIN -loop 0 "$ALARM_FILE" >/dev/null 2>&1 &
mplayer_pid=$!

notify-send -a "Alarm" -u normal -t 3000 "Your reminder is now active!"

echo -e "\n ${BGREEN}󰹲${NC} Press ${BGREEN}[Q]${NC} to stop the alarm."
while :; do
    read -t 0.1 -n 1 key && [[ $key =~ [Qq] ]] && {
        kill "$mplayer_pid" 2>/dev/null
        clear
        echo -e "\n${GREEN} 󰀣 Alarm stopped.${NC}"
        sleep 1
        exit $EXIT_SUCCESS
    }
done
