#!/usr/bin/env sh

# Terminate already running bar instances
killall -q tint2

uid=${UID:-$(id -u)}
# Wait until the processes have been shut down
while pgrep -u $uid -x tint2 >/dev/null; do sleep 1; done

tint2
