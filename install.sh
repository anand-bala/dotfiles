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

install_alacritty() {
  mkdir -pv $config_dir/alacritty
  __ln_at $config_dir/alacritty $SCRIPTPATH/alacritty/*
}

install_starship() {
  rm -rf $config_dir/starship/starship.toml
  mkdir -pv $config_dir/starship
  __ln_at $config_dir/starship $SCRIPTPATH/starship/*
}

install_kitty() {
  rm -rf "$config_dir/kitty/*"
  mkdir -pv $config_dir/kitty
  __ln_at $config_dir/kitty $SCRIPTPATH/kitty/*
}

install_fish() {
  src=$SCRIPTPATH/fish
  dest=$config_dir/fish
  mkdir -pv $dest
  for node in $src/*; do
    if [[ -d "$node" ]]; then
      mkdir -pv $dest/$(basename $node)
      for f in $node/*; do
        __ln_at $dest/$(basename $node) $(readlink -f $f)
      done

    elif [[ -f "$node" ]]; then
      __ln_at $dest $(readlink -f $node) 
    fi
  done
  # __ln_at $dest $src/*
}

install_nvim() {
  src=$SCRIPTPATH/nvim
  dest=$config_dir/nvim
  rm -rf $dest
  mkdir -pv $dest
  __ln_at $dest $src/*
}

install_git() {
  src=$SCRIPTPATH/git
  dest=$config_dir/git
  mkdir -pv $dest
  __ln_at $dest $src/*
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
    git )
      echo "Install config for git (global)"
      install_git
      ;;
    conda )
      echo "Install config for conda"
      install_conda
      ;;
    starship )
      echo "Installing config for starship prompt"
      install_starship
      ;;
    alacritty )
      echo "Installing config for Alacritty"
      install_alacritty
      ;;
    *)
      echoerr "'$1'?!? I have no idea what you're talking about?!"
  esac
  shift
done


