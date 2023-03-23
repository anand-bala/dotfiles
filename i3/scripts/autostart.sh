#!/usr/bin/env bash

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
script_dir=$config_home/i3/scripts

if command -v nitrogen &> /dev/null; then
  nitrogen --restore
fi

# if command -v polybar &> /dev/null; then
#   # Terminate already running bar instances
#   # If all your bars have ipc enabled, you can use 
#   polybar-msg cmd quit
#   # Otherwise you can use the nuclear option:
#   # killall -q polybar
#
#   # Launch
#   echo "---" | tee -a ~/.cache/polybar.log
#   polybar 2>&1 | tee -a ~/.cache/polybar.log &
#   disown $!
# fi

# if command -v pasystray &> /dev/null; then
#   killall pasystray
#   pasystray &> /dev/null
#   disown $!
# fi

# Autostart XDG-based applications
if command -v dex &> /dev/null; then
  dex -a -s $config_home/autostart
elif command -v dex-autostart &> /dev/null; then
  dex-autostart -a -s $config_home/autostart
fi
