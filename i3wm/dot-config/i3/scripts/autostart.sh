#!/usr/bin/env bash

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"

launch_if_not_running() {
  if (("$#" != "1")); then
    return
  fi
  local daemon_exe
  daemon_exe="$1"
  if type "$daemon_exe" >/dev/null; then
    if ! pgrep -u "$UID" -x "$daemon_exe" >/dev/null; then
      eval "$1" </dev/null &
      disown
    fi
  fi
}

launch_x_daemons() {
  if [[ -n "${WAYLAND_DISPLAY+x}" ]]; then
    return
  fi
  local _autostart_daemons
  # Move i3wm autostart here
  declare -a _autostart_daemons=(
    picom # Compositor
    xsettingsd
    xfce4-power-manager
  )
  for daemon_exe in "${_autostart_daemons[@]}"; do
    launch_if_not_running "$daemon_exe"
  done
}
launch_x_daemons

declare -a _autostart_daemons=(
  lxpolkit
  nm-applet
  pasystray
  autotiling # i3wm tiling plugin
)
for daemon_exe in "${_autostart_daemons[@]}"; do
  launch_if_not_running "$daemon_exe"
done

# Autostart XDG-based applications
if type dex >/dev/null; then
  dex -a -s "$config_home/autostart"
elif type dex-autostart >/dev/null; then
  dex-autostart -a -s "$config_home/autostart"
fi

if type xinput >/dev/null; then
  xinput list --name-only | grep 'Touchpad' | {
    while read -r touchpad_dev; do
      tapping_enabled='libinput Tapping Enabled'
      tapping_drag_enabled='libinput Tapping Drag Enabled'
      tapping_natural_scrolling_enabled='libinput Natural Scrolling Enabled'

      xinput set-prop "$touchpad_dev" "$tapping_enabled" 1
      xinput set-prop "$touchpad_dev" "$tapping_drag_enabled" 1
      xinput set-prop "$touchpad_dev" "$tapping_natural_scrolling_enabled" 1
    done
  }
fi
