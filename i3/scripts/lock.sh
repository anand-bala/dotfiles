#!/usr/bin/env bash

backgrounds_dir=$HOME/.config/i3/backgrounds

clean_scrot() {
  rm /tmp/*screen*.png
}

revert() {
  clean_scrot
  xset dpms 0 0 0
}

# Cleanup scrot and setup lock screen
clean_scrot
trap revert HUP INT TERM
xset +dpms dpms 0 0 5

# Take screenshot, blur it, and Rickify
scrot -d 1 /tmp/screen_locked.png
mogrify -scale 10% -scale 1000% /tmp/screen_locked.png
convert -composite \
  /tmp/screen_locked.png $backgrounds_dir/rick_and_morty_lock.png \
  -gravity South -geometry -20x1200 /tmp/screen_locked.png
i3lock -i /tmp/screen_locked.png

# Cleanup scrot and reset
revert
