#!/usr/bin/env bash

DMENU="rofi -dmenu -p Logout"

TITLES=(Cancel Logout)
COMMANDS=(true "i3-msg exit")

function gen_entries ()
{
  for a in $(seq 0 $(( ${#TITLES}-1 )))
  do
    echo $a ${TITLES[a]}
  done
}

SEL=$( gen_entries | $DMENU  | awk '{print $1}' )

if [[ $? -eq 0 ]]; then
  ${COMMANDS[$SEL]}
fi


