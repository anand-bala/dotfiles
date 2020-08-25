# -----------------------------------------------------------------------------
# Setup PATH from scratch
# -----------------------------------------------------------------------------

# Setup macOS specific paths: use https://github.com/oh-my-fish/plugin-osx/

# Common directories to add, if they exist
for p in "$HOME/bin" "$HOME/.local/bin" "/snap/bin"
  if test -d $p
    and not contains -- $p $PATH
      set -gx PATH $p $PATH
  end
end

if type -q nvim
  set -gx EDITOR nvim
else
  set -gx EDITOR vim
end
alias e="$EDITOR"


# I keep my fish plugins in ~/.fishpkg and add them to my fishfile.

# --- FZF config
if test -e $HOME/.fzf/bin/fzf
  contains -- $HOME/.fzf/bin $PATH
  or set -gx   PATH  $HOME/.fzf/bin $PATH
end

# --- Golang config
if test -d /usr/local/go
  set -x GOROOT   /usr/local/go
  set -x GOHOME   $HOME/go
  contains -- $GOROOT/bin $PATH; or set -gx PATH $GOROOT/bin $PATH
  contains -- $GOHOME/bin $PATH; or set -gx PATH $GOHOME/bin $PATH
end

# -- Custom functions for productivity

function chpwd --on-variable PWD
    set -l cursor_pos (commandline --cursor)
    # Only show directory listing in interactive mode when not tab completing
    if test $cursor_pos -eq 0 ;and status --is-interactive
        ll
    end
end

set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml

if command -sq -- flatpak
  contains -- $HOME/.local/share $XDG_DATA_DIRS
    or set -gx --path XDG_DATA_DIRS $HOME/.local/share $XDG_DATA_DIRS

  contains -- $HOME/.local/share/flatpak/exports/share $XDG_DATA_DIRS
    or set -gx --path XDG_DATA_DIRS $XDG_DATA_DIRS $HOME/.local/share/flatpak/exports/share

  contains -- /var/lib/flatpak/exports/share $XDG_DATA_DIRS
    or set -gx --path XDG_DATA_DIRS $XDG_DATA_DIRS /var/lib/flatpak/exports/share
end
