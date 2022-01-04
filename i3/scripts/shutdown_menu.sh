#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

rofi -modi "Powermenu:$SCRIPT_DIR/poweroff.sh" \
  -theme ~/.config/rofi/powermenu.rasi \
  -icon-theme "Papirus" \
  -show Powermenu
