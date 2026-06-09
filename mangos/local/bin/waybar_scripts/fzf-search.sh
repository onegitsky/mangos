#!/bin/bash
# music-fzf - Enter = Play • Ctrl+Q = Queue (Stable)

TITLE="Music Search"
MUSIC_DIR="/games/Music"
MPD_SOCKET="/run/user/1000/mpd/socket"

foot --title "$TITLE" bash -c '
    export MPD_HOST="'$MPD_SOCKET'"

    echo "Loading music library..."

    CHOICE=$(mpc listall 2>/dev/null | 
        awk -F/ '\''{
            fullpath = $0
            filename = $NF
            folder = (NF >= 2) ? $(NF-1) : ""
            
            artist = folder; gsub(/^.* - /, "", artist)
            album = folder; gsub(/ - .*$/, "", album)
            
            song = filename
            gsub(/^[0-9]+[[:space:]-._]*/, "", song)
            gsub(/\.(mp3|flac|ogg|m4a|wav|opus|webm)$/, "", song)
            
            if (artist != "" && song != "" && album != "") {
                display = artist " - " song " - " album
            } else if (artist != "" && song != "") {
                display = artist " - " song
            } else {
                display = song
            }
            
            printf "%s\t%s\n", display, fullpath
        }'\'' | 
        sort -u |
        fzf --prompt="Search: " \
            --height=100% \
            --border=none \
            --margin=1,2 \
            --no-info \
            --delimiter="\t" \
            --with-nth=1 \
            --preview="echo {} | cut -f1" \
            --preview-window=up:8%,border-horizontal \
            --header="Enter = Play | Ctrl+Q = Queue | Esc = Cancel" \
            --expect=enter,ctrl-q)

    # Parse the output
    KEY=$(echo "$CHOICE" | head -n 1)
    SELECTION=$(echo "$CHOICE" | tail -n 1)

    if [ -n "$SELECTION" ]; then
        FULL_PATH="'$MUSIC_DIR'/"$(echo "$SELECTION" | cut -f2)
        DISPLAY_NAME=$(echo "$SELECTION" | cut -f1)

        COVER="/tmp/music_cover_$$.jpg"
        ffmpeg -y -i "$FULL_PATH" -an -vf scale=256:256 "$COVER" 2>/dev/null || true

        if [[ "$KEY" == "ctrl-q" ]]; then
            # Queue the song
            SONG_PATH=$(echo "$SELECTION" | cut -f2)

            if mpc add "$SONG_PATH" >/dev/null 2>&1; then
                notify-send -i "$COVER" "Added to Queue" "$DISPLAY_NAME"
            else
                notify-send "Error" "Failed to add to queue"
            fi
        else
            # Play immediately (Enter) without destroying queue
            SONG_PATH=$(echo "$SELECTION" | cut -f2)

            POS=$(mpc playlist | wc -l)

            if mpc add "$SONG_PATH" >/dev/null 2>&1 &&
               mpc play $((POS + 1)) >/dev/null 2>&1; then

                if [ -f "$COVER" ]; then
                    notify-send -i "$COVER" "Now Playing" "$DISPLAY_NAME"
                else
                    notify-send "Now Playing" "$DISPLAY_NAME" --icon=media-playback-start
                fi
            else
                notify-send "Error" "Failed to play track" --icon=dialog-error
            fi
        fi

        rm -f "$COVER" 2>/dev/null
    fi
'
