#!/usr/bin/env bash

revert() {
  rm /tmp/*screen*.png
  xset dpms 0 0 0
}
trap revert HUP INT TERM
xset +dpms dpms 0 0 5

scrot -d 1 /tmp/screen_locked.png
mogrify -scale 10% -scale 1000% /tmp/screen_locked.png
convert -composite /tmp/screen_locked.png ~/backgrounds/rick_and_morty_lock.png \
  -gravity South -geometry -20x1200 /tmp/screen_locked.png
i3lock -i /tmp/screen_locked.png
revert
