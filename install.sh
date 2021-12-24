#!/usr/bin/env bash
shopt -s nullglob dotglob     # To include hidden files
shopt -s failglob             # Fail on bad glob expansion
set -eu -o pipefail

# Some helpers

echoerr() {
  printf "%s\n" "$*" >&2;
}

__ls_files() {
  ls -p $1 | grep -v /
}

__ln_at() {
  ln -vsfn -t $1 ${@:2}
}

# Actual Installers

config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
SCRIPTPATH="$( cd "$(dirname $(readlink -f "$0"))" ; pwd -P )"


_default_install() {
  name="$1"
  src=$SCRIPTPATH/$name
  dest=$config_dir/$name
  rm -f $dest
  ln -vs $src $dest
}

install_gdb() {
  src=$SCRIPTPATH/gdb
  dest=$config_dir/gdb

  ln -vs $src $dest
  echo "source $dest/gdbinit" > $HOME/.gdbinit
}

install_tmux() {
  rm -rf $config_dir/tmux/tmux.conf
  mkdir -pv $config_dir/tmux
  __ln_at $config_dir/tmux $SCRIPTPATH/tmux/*
}

install_git() {
  _default_install git

  curl -SL \
    "https://www.gitignore.io/api/vim,tags,linux,visualstudiocode,direnv" \
    -o ~/.gitignore
}

install_conda() {
  src=$SCRIPTPATH/conda
  dest=$HOME/.conda
  mkdir -pv $dest
  __ln_at $dest $src/*
}


# Install Script

if [[ $# -lt 1 ]]; then
  echoerr "Why are you asking me to install nothing?!"
  echoerr "USAGE: $0 [neovim|nvim] [fish] [kitty] [git]"
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    bat \
      | direnv \
      | fd \
      | colcon \
      | dunst \
      | polybar \
      | polybar-laptop \
      | conky \
      | xkb \
      | i3 \
      | i3blocks \
      | i3status \
      | rofi \
      | alacritty \
      | starship \
      | kitty \
      | fish \
      | neovim | nvim )
      echo "Installing config for $1"
      _default_install $1
      ;;
    git )
      echo "Install config for git (global)"
      install_git
      ;;
    conda )
      echo "Install config for conda"
      install_conda
      ;;
    gdb )
      echo "Installing config for gdb"
      install_gdb
      ;;
    tmux )
      echo "Installing config for tmux"
      install_tmux
      ;;
    *)
      echoerr "'$1'?!? I have no idea what you're talking about?!"
  esac
  shift
done


