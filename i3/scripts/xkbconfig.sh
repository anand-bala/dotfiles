#!/usr/bin/env bash

XKB_CONFIG_DIR=$XDG_CONFIG_HOME/xkb

xkbcomp -I$XKB_CONFIG_DIR $XKB_CONFIG_DIR/keymap/custom $DISPLAY
