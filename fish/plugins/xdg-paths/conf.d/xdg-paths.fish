# Set default XDG variables
# See: https://specifications.freedesktop.org/basedir-spec/latest/ar01s03.html

set -l data_home    $HOME/.local/share
set -l config_home  $HOME/.config
set -l cache_home   $HOME/.cache

contains -- $data_home $XDG_DATA_HOME
  or set -gx --path XDG_DATA_HOME $data_home $XDG_DATA_HOME

contains -- $data_home $XDG_DATA_DIRS
  or set -gx --path XDG_DATA_DIRS $data_home $XDG_DATA_DIRS

contains -- $config_home $XDG_CONFIG_HOME
  or set -gx --path XDG_CONFIG_HOME $config_home $XDG_CONFIG_HOME

contains -- $cache_home $XDG_CACHE_HOME
  or set -gx --path XDG_CACHE_HOME $cache_home $XDG_CACHE_HOME
