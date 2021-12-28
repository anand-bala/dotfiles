# -- Remove the intro
set -g fish_greeting "🐟"

# -- Common directories to add to PATH, if they exist
for p in "$HOME/bin" "$HOME/.local/bin"
  fish_add_path -gP $p
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
  fish_add_path -gP $HOME/.fzf/bin/
end
set -gx FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'


# --- Miniconda config
if test -e $HOME/miniconda3/etc/fish/conf.d/conda.fish
  source $HOME/miniconda3/etc/fish/conf.d/conda.fish
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
