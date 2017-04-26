#!/bin/bash

source $HOME/config/prompt.sh

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
export TERM="xterm-color"


export EDITOR="vim"

# Convenience shortcuts
alias clr="clear"
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

# Config shortcuts
alias envconfig="$EDITOR ~/config/env.sh"
alias bashconfig="$EDITOR ~/.bashrc"
alias bashsource="source ~/.bashrc"
alias vimconf="$EDITOR ~/.vimrc"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no

# Server shortcuts
alias timberlakessh="ssh anandbal@timberlake.cse.buffalo.edu"

# Workspace shortcuts
export OPS_WS="~/workspace/ops-class-ws"
alias opsws="cd $OPS_WS"
export DRONES_WS="~/workspace/drones"
alias dronesws="cd $DRONES_WS"
export OPENAI_WS="~/workspace/openai-gym"
alias openaiws="cd $OPENAI_WS"
export MICROPROC_WS="~/workspace/microproc"
alias microprocsws="cd $MICROPROC_WS"
export ROS_WS="~/workspace/ros_ws"
alias ws_ros="cd $ROS_WS"

# Java config
export PATH=$PATH:/usr/lib/jvm/java-8-oracle/bin:/usr/lib/jvm/java-8-oracle/db/bin:/usr/lib/jvm/java-8-oracle/jre/bin

# Qt config
export QT_SELECT=opt-qt54

# Virtualenv config

export WORKON_HOME=~/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh

# Ardupilot setup

export DRONES_TOOLS_PATH=~/workspace/drones/tools
export ARDUPILOT_PATH=$DRONES_TOOLS_PATH/ardupilot
export PATH=$PATH:$DRONES_TOOLS_PATH/jsbsim/src
export PATH=$PATH:$ARDUPILOT_PATH/Tools/autotest
export PATH=/usr/lib/ccache:$PATH


# ROS config
source /opt/ros/indigo/setup.bash

# Python config
source ~/config/pyconf.sh

# Art stuff
export PATH=$PATH:~/workspace/art/tools/playscii

