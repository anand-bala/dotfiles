# Bash Completion
# ------------------------------------------------------------

if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi

export HOMEBREW_GITHUB_API_TOKEN="a4b8b08f20b83199dfb4588cb872bf87a1b1f1a6"

# Change Prompt
# ------------------------------------------------------------
export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUNTRACKEDFILES=true

export PS1='\[\033[38;5;4m\]{\[$(tput sgr0)\]\[\033[38;5;11m\]\A\[$(tput sgr0)\]\[\033[38;5;4m\]}\[$(tput sgr0)\] [\u@\h : \W]$(__git_ps1 " (%s)") \$ '

# Set Paths
# ------------------------------------------------------------
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/sbin:/opt/X11/bin:/Library/TeX/texbin"

# Set Default Editor
# ------------------------------------------------------------
export EDITOR=vim

# Set default blocksize for ls, df, du
# from this: http://hints.macworld.com/comment.php?mode=view&cid=24491
# ------------------------------------------------------------
export BLOCKSIZE=1k

# Add color to terminal
# (this is all commented out as I use Mac Terminal Profiles)
# from http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
# ------------------------------------------------------------
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Aliases for better Command Line
# ------------------------------------------------------------
source ${HOME}/.aliases

# lr:  Full Recursive Directory Listing
# ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

# mans:   Search manpage given in agument '1' for term given in argument '2' (case insensitive)
#         displays paginated result with colored search terms and two lines surrounding each hit.             Example: mans mplayer codec
# --------------------------------------------------------------------
mans () {
	man $1 | grep -iC2 --color=always $2 | less
}

# showa: to remind yourself of an alias (given some part of it)
# ------------------------------------------------------------
showa () { /usr/bin/grep --color=always -i -a1 $@ ~/Library/init/bash/aliases.bash | grep -v '^\s*$' | less -FSRXc ; }


# SEARCHING
# ---------------------------

alias qfind="find . -name "                 # qfind:    Quickly search for file
ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

# spotlight: Search for a file using MacOS Spotlight's metadata
# -----------------------------------------------------------
spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }


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
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

#   ---------------------------------------
#   7.  SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------

alias mountReadWrite='/sbin/mount -uw /'    # mountReadWrite:   For use when booted into single-user

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

# Dev Environmant
# ----------------------------

export PATH="$HOME/bin:$PATH"

# Rust Cargo
export PATH="$HOME/.cargo/bin:$PATH"

# PyEnv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# Golang setup
export GOROOT=/usr/local/opt/go/libexec
export GOPATH=$HOME/go
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

# Android SDK
export ANDROID_HOME=$HOME/Library/Android/sdk 
#export PATH=$PATH:$ANDROID_HOME/tools 
#export PATH=$PATH:$ANDROID_HOME/platform-tools

# rbEnv
#eval "$(rbenv init -)"

# The next line updates PATH for the Google Cloud SDK.
#if [ -f '/Users/anandbalakrishnan/tools/google-cloud-sdk/path.bash.inc' ]; then source '/Users/anandbalakrishnan/tools/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
#if [ -f '/Users/anandbalakrishnan/tools/google-cloud-sdk/completion.bash.inc' ]; then source '/Users/anandbalakrishnan/tools/google-cloud-sdk/completion.bash.inc'; fi

# ROS


