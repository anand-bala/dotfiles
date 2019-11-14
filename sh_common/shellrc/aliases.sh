# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

[ -x "$(command -v kitty)" ] && alias ssh='kitty +kitten ssh'
[ -x "$(command -v nvim)" ] && alias vim='nvim'

alias e="$EDITOR"

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlhp'                       # Preferred 'ls' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
cd() { builtin cd "$@"; ls -l; }            # Always list directory contents upon 'cd'
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias ~="cd ~"                              # ~:            Go Home
alias c='clear'                             # c:            Clear terminal display
alias whicht='type -all'                     # which:        Find executables
alias pathe='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
alias show_options='shopt'                  # Show_options: display bash options settings
alias fix_stty='stty sane'                  # fix_stty:     Restore terminal settings when screwed up
mkcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
alias config='/usr/bin/env git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias m="make"
alias e="$EDITOR"

if [ "$(uname)" = "Darwin" ]; then

  trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash

  alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder

  # showa: to remind yourself of an alias (given some part of it)
  # ------------------------------------------------------------
  showa () { /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc ; }

  # spotlight: Search for a file using MacOS Spotlight's metadata
  # -----------------------------------------------------------
  spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }

elif [ "$(uname)" = "Linux" ]; then
  alias myip="hostname -I"
fi

# lr:  Full Recursive Directory Listing
# ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

# mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#         displays paginated result with colored search terms and two lines surrounding each hit.             Example: mans mplayer codec
# --------------------------------------------------------------------
mans () {
  man $1 | grep -iC2 --color=always $2 | less
}


