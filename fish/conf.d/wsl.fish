if set -q WSL_DISTRO_NAME
  set -gx BROWSER wslview

  set -l wslip (ip route | awk '/default via/' | cut -d" " -f3)
  set -gx DISPLAY "$wslip:0.0"
  set -gx LIBGL_ALWAYS_INDIRECT 1
end
