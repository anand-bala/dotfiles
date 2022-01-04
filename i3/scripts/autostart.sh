#!/usr/bin/env bash

set -euo pipefail

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
script_dir=$config_home/i3/scripts

# Autostart XDG-based applications
if command -v dex &> /dev/null; then
  dex -a -e i3wm -s $config_home/autostart
elif command -v dex-autostart &> /dev/null; then
  dex-autostart -a -e i3wm -s $config_home/autostart
fi

