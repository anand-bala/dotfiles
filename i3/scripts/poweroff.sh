#!/usr/bin/env bash

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

if [ -z "$@" ]; then
    echo -en "Lock\0icon\x1fsystem-lock-screen\n"
    echo -en "Logout\0icon\x1fsystem-log-out\n"
    # echo -en "Suspend\0icon\x1fsystem-suspend\n"
    # echo -en "Hibernate\0icon\x1fsystem-hibernate\n"
    echo -en "Hybrid-sleep\0icon\x1fsystem-hibernate\n"
    echo -en "Shutdown\0icon\x1fsystem-shutdown\n"
    echo -en "Reboot\0icon\x1fsystem-reboot\n"
else
    if [ "$1" = "Shutdown" ]; then
        systemctl poweroff
    elif [ "$1" = "Logout" ]; then
        i3-msg exit
    elif [ "$1" = "Reboot" ]; then
        systemctl reboot
    elif [ "$1" = "Suspend" ]; then
        systemctl suspend
    elif [ "$1" = "Hibernate" ]; then
        systemctl hibernate
    elif [ "$1" = "Hybrid-sleep" ]; then
        systemctl hybrid-sleep
    elif [ "$1" = "Lock" ]; then
        xflock4
    fi
fi
