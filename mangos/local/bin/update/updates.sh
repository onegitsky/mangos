#!/usr/bin/env bash

OFFICIAL_UPDATES=$(checkupdates | wc -l)
AUR_UPDATES=$(yay -Qua | wc -l)
TOTAL_UPDATES=$((OFFICIAL_UPDATES + AUR_UPDATES))
LAST_UPDATED=$(grep "\[PACMAN\] starting full system upgrade" /var/log/pacman.log | tail -1 | awk '{print substr($1, 10, 2) "/" substr($1, 7, 2)}' | sed 's/\//-/')

if [ -z "$LAST_UPDATED" ]; then
    LAST_UPDATED="Unknown"
fi

if [ "$TOTAL_UPDATES" -eq 0 ]; then
    notify-send -a "System Updater" -u normal \
        "System Updates" \
        "No updates available.\nLast Updated: $LAST_UPDATED"
else
    notify-send -u normal \
        "System Updates" \
        "$TOTAL_UPDATES updates available ($AUR_UPDATES AUR).\nLast Updated: $LAST_UPDATED"
fi
