
if command -v thefuck 2>/dev/null; then
  eval $(thefuck --alias)
fi
alias bashconfig="$EDITOR ~/.bash_profile"
alias bashsource="source ~/.bash_profile"

alias e="$EDITOR"
alias mux="tmux-next"

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
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
mcd () { mkdir -p "$1" && cd "$1"; }        # mcd:          Makes new Dir and jumps inside
alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop

alias config='/usr/bin/env git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

alias m="make"
alias e="$EDITOR"

trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash

if [ "$(uname)" == "Darwin" ]; then
  alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder

  # showa: to remind yourself of an alias (given some part of it)
  # ------------------------------------------------------------
  showa () { /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc ; }

  # spotlight: Search for a file using MacOS Spotlight's metadata
  # -----------------------------------------------------------
  spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }

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


# SEARCHING
# ---------------------------

alias qfind="find . -name "                 # qfind:    Quickly search for file
ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string


# PROCESS MANAGEMENT
# ---------------------------

#   memHogsTop, memHogsPs:  Find memory hogs
#   -----------------------------------------------------
alias memHogsTop='top -l 1 -o rsize | head -20'
alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#   cpuHogs:  Find CPU hogs
#   -----------------------------------------------------
alias cpu_hogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#   topForever:  Continual 'top' listing (every 10 seconds)
#   -----------------------------------------------------
# alias topForever='top -l 9999999 -s 10 -o cpu'

#   ttop:  Recommended 'top' invocation to minimize resources
#   ------------------------------------------------------------
#       Taken from this macosxhints article
#       http://www.macosxhints.com/article.php?story=20060816123853639
#   ------------------------------------------------------------
alias ttop="top -R -F -s 10 -o rsize"

# my_ps: List processes owned by my user:
# ------------------------------------------------------------
my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }


# NETWORKING
# ---------------------------

ip() { whoami; echo -n "- Public IP: "; curl ipecho.net/plain; echo; echo "- Internal IP: $(ipconfig getifaddr en1)";}
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='lsof -i -P'             # lsock:        Display open sockets
alias lsockU='lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

#   ---------------------------------------
#   7.  SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------


if [ "$(uname)" == "Darwin" ]; then

  #   cleanupDS:  Recursively delete .DS_Store files
  #   -------------------------------------------------------------------
  alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

  #   finderShowHidden:   Show hidden files in Finder
  #   finderHideHidden:   Hide hidden files in Finder
  #   -------------------------------------------------------------------
  alias finderShowHidden='defaults write com.apple.finder ShowAllFiles TRUE'
  alias finderHideHidden='defaults write com.apple.finder ShowAllFiles FALSE'

  #   cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
  #   -----------------------------------------------------------------------------------
  alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

  #    screensaverDesktop: Run a screensaver on the Desktop
  #   -----------------------------------------------------------------------------------
  alias screensaverDesktop='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background'

fi

# Python stuff
alias nbstrip_jq="jq --indent 1 \
  '(.cells[] | select(has(\"outputs\")) | .outputs) = []  \
  | (.cells[] | select(has(\"execution_count\")) | .execution_count) = null  \
  | .metadata = {\"language_info\": {\"name\": \"python3\", \"pygments_lexer\": \"ipython3\"}} \
  | .cells[].metadata = {} \
  '"

