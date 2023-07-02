# -- Remove the intro
set -g fish_greeting "🐟"

# -- Common directories to add to PATH, if they exist
for p in "$HOME/bin" "$HOME/.local/bin"
  fish_add_path -gP $p
end

if type -q nvim
  if type -q nvr
    set -gx EDITOR "nvr -s"
  else
    set -gx EDITOR nvim
  end
end
alias e="$EDITOR"

if command -sq -- exa
  alias ls "exa"
  alias ll "exa -l"
  alias tree "exa -l --tree"
end

alias less "less -R --use-color"
set -gx PAGER "less -R --use-color -Dd+r -Du+b"
set -gx MANPAGER "less -R --use-color -Dd+r -Du+b"

# --- Colorize GCC output
set -gx GCC_COLORS "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

# --- FZF config
if test -e $HOME/.fzf/bin/fzf
  fish_add_path -gP $HOME/.fzf/bin/
end
set -gx FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f $HOME/miniconda3/bin/conda
    eval $HOME/miniconda3/bin/conda "shell.fish" "hook" $argv | source
end

if test -f "$HOME/miniconda3/etc/fish/conf.d/mamba.fish"
    source "$HOME/miniconda3/etc/fish/conf.d/mamba.fish"
end
# <<< conda initialize <<<

# --- Direnv config
if command -sq -- direnv 
  direnv hook fish | source
end

# --- Custom prompt (last plugin)
if command -sq -- starship
  set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
  starship init fish | source
end

