# Set default XDG variables
# See: https://specifications.freedesktop.org/basedir-spec/latest/ar01s03.html

if test -n "$XDG_DATA_DIRS"
  set -gx --path XDG_DATA_DIRS "/usr/local/share" "/usr/share"
end
if test -n "$XDG_CONFIG_DIRS"
  set -gx --path XDG_CONFIG_DIRS "/etc/xdg"
end

set -l data_home    $HOME/.local/share
set -l config_home  $HOME/.config
set -l cache_home   $HOME/.cache
set -l state_home   $HOME/.local/state

contains -- $data_home $XDG_DATA_HOME
  or set -gx --path XDG_DATA_HOME $data_home

contains -- $data_home $XDG_DATA_DIRS
  or set -gx --path XDG_DATA_DIRS $data_home $XDG_DATA_DIRS

contains -- $config_home $XDG_CONFIG_HOME
  or set -gx --path XDG_CONFIG_HOME $config_home

contains -- $cache_home $XDG_CACHE_HOME
  or set -gx --path XDG_CACHE_HOME $cache_home

contains -- $state_home $XDG_STATE_HOME
  or set -gx --path XDG_STATE_HOME $state_home

# --- Setup paths for flatpak
if command -sq -- flatpak

  contains -- $HOME/.local/share/flatpak/exports/share $XDG_DATA_DIRS
    or set -gx --path XDG_DATA_DIRS $XDG_DATA_DIRS $HOME/.local/share/flatpak/exports/share

  contains -- /var/lib/flatpak/exports/share $XDG_DATA_DIRS
    or set -gx --path XDG_DATA_DIRS $XDG_DATA_DIRS /var/lib/flatpak/exports/share
end
