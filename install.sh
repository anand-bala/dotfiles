#!/usr/bin/env bash
shopt -s nullglob dotglob     # To include hidden files


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
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"


install_kitty() {
  rm -rf $config_dir/kitty/*
  mkdir -pv $config_dir/kitty
  __ln_at $config_dir/kitty $SCRIPTPATH/kitty/*
}

install_fish() {
  src=$SCRIPTPATH/fish
  dest=$config_dir/fish
  rm -rf $dest
  mkdir -pv $dest
  __ln_at $dest $src/*
}

install_nvim() {
  src=$SCRIPTPATH/nvim
  dest=$config_dir/nvim
  rm -rf $dest
  mkdir -pv $dest
  __ln_at $dest $src/*
}


# Install Script

if [[ $# -lt 1 ]]; then
  echoerr "Why are you asking me to install nothing?!"
  echoerr "USAGE: $0 [neovim|nvim] [fish] [kitty]"
  exit 1
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    neovim|nvim )
      echo "Install config for Neovim"
      install_nvim
      ;;
    fish )
      echo "Install config for Fish Shell"
      install_fish
      ;;
    kitty )
      echo "Install config for kitty terminal"
      install_kitty
      ;;
    *)
      echoerr "'$1'?!? I have no idea what you're talking about?!"
  esac
  shift
done


