#!/usr/bin/env bash

DMENU="rofi -dmenu -p Shutdown"
SYSTEMCTL="systemctl"

TITLES=(Cancel Shutdown Reboot Hibernate Suspend Halt)
COMMANDS=(true poweroff reboot hibernate suspend halt)

function gen_entries ()
{
  for a in $(seq 0 $(( ${#TITLES}-1 )))
  do
    echo $a ${TITLES[a]}
  done
}

SEL=$( gen_entries | $DMENU  | awk '{print $1}' )

if [[ $? -eq 0 ]]; then
  if [[ $SEL -eq 0 ]]; then
    ${COMMANDS[$SEL]}
  else
    ${SYSTEMCTL} ${COMMANDS[$SEL]}
  fi
fi

