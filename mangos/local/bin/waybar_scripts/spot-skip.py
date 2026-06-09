#!/usr/bin/env python3
import subprocess
import requests
from PIL import Image
import os
import io
import urllib.request
from urllib.parse import urlparse, unquote

# Get metadata
def get_metadata(key):
    try:
        return subprocess.check_output(
            ['playerctl', '--player=mpd', 'metadata', '--format', f'{{{{{key}}}}}'],
            text=True
        ).strip()
    except subprocess.CalledProcessError:
        return ""

artist = get_metadata("artist")
title = get_metadata("title")
art_url = get_metadata("mpris:artUrl")

# Combine artist and title into a single line
track_info = f"{artist} - {title}" if artist and title else title or artist or "Unknown Track"

# Temporary icon path
temp_icon = "/tmp/spotify_album_art.png"   # you can keep the name, it's just a temp file

# Download / copy album art (handles both http(s) and file:// URLs)
if art_url:
    try:
        parsed = urlparse(art_url)
        
        if parsed.scheme in ('http', 'https'):
            # Remote URL (Spotify-style)
            response = requests.get(art_url, timeout=5)
            if response.ok:
                image = Image.open(io.BytesIO(response.content))
                image.save(temp_icon)
                
        elif parsed.scheme == 'file' or not parsed.scheme:
            if parsed.scheme == 'file':
                local_path = unquote(parsed.path)   # decode %20 etc.
            else:
                local_path = art_url  # sometimes it's already a plain path
                
            if os.path.exists(local_path):
                # Just copy the existing image (fastest)
                with open(local_path, 'rb') as f:
                    image = Image.open(f)
                    image.save(temp_icon)
            else:
                print(f"Local art file not found: {local_path}")
                
    except Exception as e:
        print(f"Failed to process album art from {art_url}: {e}")

# Send notification
def send_notification(icon_path=None):
    notif_title = "Track Skipped:"
    timeout = "2750"
    if icon_path and os.path.exists(icon_path):
        subprocess.run(['notify-send', '-t', timeout, '-i', icon_path, notif_title, track_info])
    else:
        subprocess.run(['notify-send', '-t', timeout, notif_title, track_info])

send_notification(temp_icon if os.path.exists(temp_icon) else None)

# Clean up
if os.path.exists(temp_icon):
    os.remove(temp_icon)
