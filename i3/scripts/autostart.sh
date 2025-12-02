#!/usr/bin/env bash

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"

# Autostart XDG-based applications
if type dex >/dev/null; then
  dex -a -s "$config_home/autostart"
elif type dex-autostart >/dev/null; then
  dex-autostart -a -s "$config_home/autostart"
fi
