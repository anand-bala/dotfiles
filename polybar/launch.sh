#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

uid=${UID:-$(id -u)}
# Wait until the processes have been shut down
while pgrep -u $uid -x polybar >/dev/null; do sleep 1; done

# Set up the required environment variables
export MONITORS=$(xrandr --query | grep " connected" | cut -d" " -f1 | head -n1)
export WIFI_DEVS=$(iw dev | grep Interface | awk '{print $2}' | head -n1)

echo "MONITORS = $MONITORS"
echo "WIFI_DEVS = $WIFI_DEVS"
polybar main
