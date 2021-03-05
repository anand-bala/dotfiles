#!/bin/sh

player_status=$(playerctl status 2> /dev/null)

playing=false
if [ "$player_status" = "Playing" ] || [ "$player_status" = "Paused" ]; then
  playing=true
else
  exit 0
fi

artist=$(playerctl metadata artist | sed -e 's/\(.\{25\}\).*$/\1.../')
title=$(playerctl metadata title | sed -e 's/\(.\{25\}\).*$/\1.../')

echo " $artist - $title"
