#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

uid=${UID:-$(id -u)}
# Wait until the processes have been shut down
while pgrep -u $uid -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
MONITORS=$(xrandr --query | grep " connected" | cut -d" " -f1)

MONITORS=$MONITORS polybar top &
MONITORS=$MONITORS polybar bottom &
