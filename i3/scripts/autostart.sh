#!/usr/bin/env bash

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
script_dir=$config_home/i3/scripts

bash "$config_home/autorandr/postswitch.d/00-always-run"

# Autostart XDG-based applications
if command -v dex &>/dev/null; then
	dex -a -s "$config_home/autostart"
elif command -v dex-autostart &>/dev/null; then
	dex-autostart -a -s "$config_home/autostart"
fi
