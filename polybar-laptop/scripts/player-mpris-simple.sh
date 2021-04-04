#!/bin/sh

# Comma-separated list of applications that should be excluded by playerctl
excluded_players="firefox"

player_status=$(playerctl -i "$excluded_players" status 2> /dev/null)

playing=""
if [ "$player_status" = "Playing" ]; then
playing=""
elif [ "$player_status" = "Paused" ]; then
playing=""
else
  echo ""
  exit 0
fi

artist=$(playerctl -i "$excluded_players" metadata artist | sed -e 's/\(.\{25\}\).*$/\1.../')
title=$(playerctl -i "$excluded_players" metadata title | sed -e 's/\(.\{25\}\).*$/\1.../')

echo " $playing $artist - $title"
