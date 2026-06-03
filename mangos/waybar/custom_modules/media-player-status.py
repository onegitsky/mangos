#!/usr/bin/env python

import html
import json
import gi
import sys
import argparse
gi.require_version('Playerctl', '2.0')
from gi.repository import Playerctl, GLib
from pathlib import Path

ARTIST = 'xesam:artist'
TITLE = 'xesam:title'

def get_wal_color():
    try:
        with open(Path.home() / ".cache/wal/colors") as f:
            colors = f.read().splitlines()

        return colors[4]
    except Exception:
        return "#e17d94"  # fallback

ICON_COLOR = get_wal_color()

ICONS = {
    'default': f'<span color="{ICON_COLOR}"> </span>',
    'paused': ''
}

last_status = None

def find_active_player(manager, vanished_player, target_player=None):
    for player in manager.props.players:
        if player == vanished_player or (target_player and player.props.player_name != target_player):
            continue
        if player.props.playback_status != Playerctl.PlaybackStatus.STOPPED:
            return player
    return None

def get_status(manager, vanished_player, target_player=None):
    player = find_active_player(manager, vanished_player, target_player)
    if not player:
        return '', '', 'stopped'
    
    name = player.props.player_name
    metadata = player.props.metadata
    title = metadata[TITLE] if TITLE in metadata.keys() else None
    artist = metadata[ARTIST][0] if ARTIST in metadata.keys() else None
    
    if name == 'quodlibet' and title == '' and artist == '':
        title = artist = None
    
    css_class = 'paused' if player.props.playback_status == Playerctl.PlaybackStatus.PAUSED else 'playing'
    icon = ICONS['paused'] if css_class == 'paused' else ICONS['default']
    
    if not title and not artist:
        return icon, f'{name.title()}: {css_class.title()}', css_class
    
    song = artist or name.title() if not title else title if not artist else f'{artist} – {title}'
    return f'{icon} {html.escape(song)}', f'{name.title()}: {song}', css_class

def print_status(manager, vanished_player=None, target_player=None):
    text, tooltip, css_class = get_status(manager, vanished_player, target_player)
    status = json.dumps({'text': text, 'tooltip': tooltip, 'class': css_class})
    global last_status
    if last_status != status:
        print(status)
        sys.stdout.flush()
        last_status = status

def on_playback_status(player, status, manager, target_player=None):
    if target_player and player.props.player_name != target_player:
        return
    manager.move_player_to_top(player)
    print_status(manager, target_player=target_player)

def on_metadata(player, metadata, manager, target_player=None):
    if target_player and player.props.player_name != target_player:
        return
    manager.move_player_to_top(player)
    print_status(manager, target_player=target_player)

def init_player(manager, name, target_player=None):
    if target_player and name.name != target_player:
        return
    player = Playerctl.Player.new_from_name(name)
    player.connect('playback-status', on_playback_status, manager, target_player)
    player.connect('metadata', on_metadata, manager, target_player)
    manager.manage_player(player)

def on_name_appeared(manager, name, _, target_player=None):
    init_player(manager, name, target_player)
    print_status(manager, target_player=target_player)

def on_player_vanished(manager, player, _, target_player=None):
    print_status(manager, player, target_player=target_player)

def init_manager(target_player=None):
    manager = Playerctl.PlayerManager()
    manager.connect('name-appeared', on_name_appeared, manager, target_player)
    manager.connect('player-vanished', on_player_vanished, manager, target_player)
    for name in manager.props.player_names:
        init_player(manager, name, target_player)
    print_status(manager, target_player=target_player)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Monitor a specific media player.')
    parser.add_argument('--player', type=str, help='Specify the player to monitor (e.g., spotify, vlc)')
    args = parser.parse_args()
    init_manager(target_player=args.player)
    GLib.MainLoop().run()
