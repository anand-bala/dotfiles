#!/bin/bash

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true

export PROMPT_COMMAND=prompt_command

RED="\[\033[0;31m\]"
YELLOW="\[\033[1;33m\]"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[1;34m\]"
PURPLE="\[\033[0;35m\]"
LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
WHITE="\[\033[1;37m\]"
LIGHT_GRAY="\[\033[0;37m\]"
COLOR_NONE="\[\e[0m\]"

prompt_command () {
 local TIME="${BLUE}[${COLOR_NONE}${YELLOW}\A${COLOR_NONE}${BLUE}]${COLOR_NONE}"
 local HOST="${YELLOW}[\u@\h]${COLOR_NONE}"
 local DIR=`local_dir`
 local BRANCH="\$(__git_ps1 ' [branch = %s]')${COLOR_NONE}"
 local PROMPT="\$"
 
 local CUR_SHELL="${BLUE}[`printf "%5s" $(basename $SHELL)`]${COLOR_NONE}"
 if test -z "$VIRTUAL_ENV"; then
   PY_VENV="${CUR_SHELL}"
 else
   PY_VENV="${BLUE}[`basename \"$VIRTUAL_ENV\"`]${COLOR_NONE}"
 fi 
 export PS1="${PY_VENV} ${HOST}${BRANCH}: ${DIR}\n${TIME} ${PROMPT} "
}

local_dir () {
  local HPWD='~'
  case $PWD in
    $HOME)
      HPWD="~";;
    $HOME/*/*)
      HPWD="${PWD#"${PWD%/*/*}/"}";;
    /*/*/*)
      HPWD="${PWD#"${PWD%/*/*}/"}";;
    *)
      HPWD="$PWD";;
  esac;
  printf "%s" "$HPWD"
}

git_status_color () {
  local git_status="$(git status 2> /dev/null)"
  if [[ ! $git_status =~ "working directory clean" ]]; then
    echo -e $RED
  elif [[ $git_status =~ "Your branch is ahead of" ]]; then
    echo -e $YELLOW
  elif [[ $git_status =~ "nothing to commit" ]]; then
    echo -e $GREEN
  else
    echo -e $LIGHT_RED
  fi
}

