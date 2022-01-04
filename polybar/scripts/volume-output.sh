#!/usr/bin/env bash

set -euo pipefail

# Icons mixed from Font Awesome 5 and Material Icons
# You can copy-paste your options for each possible action, which is more
# trouble-free but repetitive, or apply only the relevant ones (for example
# --sink-blacklist is only needed for next-sink).

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

ICONS_VOLUME=" , "
ICON_MUTED=" "
SINK_NICKNAME=(
  "--sink-nickname \"alsa_output.pci-0000_00_1f.3.analog-stereo:\""
)
FORMAT='%{T5}$VOL_ICON%{T-} ${VOL_LEVEL}%  %{T5}$ICON_SINK%{T-} $SINK_NICKNAME'

~/.config/polybar/scripts/pulseaudio-control.sh \
  --format "$FORMAT" \
  --icons-volume "$ICONS_VOLUME" \
  --icon-muted "$ICON_MUTED" \
  --sink-nicknames-from "device.description" \
  --sink-nickname "alsa_output.pci-0000_00_1f.3.analog-stereo: Headphones" \
  listen
