# -- Remove the intro
set -g fish_greeting "🐟"

# -- Common directories to add, if they exist
for p in "$HOME/bin" "$HOME/.local/bin"
  if test -d $p
    and not contains -- $p $PATH
      set -gx PATH $p $PATH
  end
end

if type -q nvim
  set -gx EDITOR nvim
  set -gx MANPAGER 'nvim +Man!'
  set -gx MANWIDTH 999
else
  set -gx EDITOR vim
end
alias e="$EDITOR"

if command -sq -- exa
  alias ls "exa"
  alias ll "exa -l"
  alias tree "exa --tree"
end

alias less "less -r"
set -gx PAGER "less -r"

# --- Colorize GCC output
set -gx GCC_COLORS "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

# --- FZF config
if test -e $HOME/.fzf/bin/fzf
  contains -- $HOME/.fzf/bin $PATH
  or set -gx   PATH  $HOME/.fzf/bin $PATH

  set -gx FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'
end

# --- Golang config
if test -d /usr/local/go
  set -x GOROOT   /usr/local/go
  set -x GOHOME   $HOME/go
  contains -- $GOROOT/bin $PATH; or set -gx PATH $GOROOT/bin $PATH
  contains -- $GOHOME/bin $PATH; or set -gx PATH $GOHOME/bin $PATH
end

# --- Miniconda config
if test -e $HOME/miniconda3/etc/fish/conf.d/conda.fish
  source $HOME/miniconda3/etc/fish/conf.d/conda.fish
end

# --- Setup paths for flatpak
if command -sq -- flatpak

  contains -- $HOME/.local/share/flatpak/exports/share $XDG_DATA_DIRS
    or set -gx --path XDG_DATA_DIRS $XDG_DATA_DIRS $HOME/.local/share/flatpak/exports/share

  contains -- /var/lib/flatpak/exports/share $XDG_DATA_DIRS
    or set -gx --path XDG_DATA_DIRS $XDG_DATA_DIRS /var/lib/flatpak/exports/share
end

# --- setup direnv
if command -sq -- direnv
  direnv hook fish | source
end

# --- Custom prompt (last plugin)
set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
starship init fish | source

# -- Custom hooks

function chpwd --on-variable PWD -d "Run ls on cd"
    set -l cursor_pos (commandline --cursor)
    # Only show directory listing in interactive mode when not tab completing
    if test $cursor_pos -eq 0 ;and status --is-interactive
        ll
    end
end
