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

# --- Miniconda config
if test -e $HOME/miniconda/etc/fish/conf.d/conda.fish
  source $HOME/miniconda/etc/fish/conf.d/conda.fish
end

# --- CUDA config
if test -d "/usr/local/cuda"
  set -gx CUDA_HOME           /usr/local/cuda
  set -gx DYLD_LIBRARY_PATH   $DYLD_LIBRARY_PATH $CUDA_HOME/lib
  set -gx LD_LIBRARY_PATH     $LD_LIBRARY_PATH $CUDA_HOME/lib64
  if test -d /usr/local/cuda/extras/CUPTI/lib64
    set -gx LD_LIBRARY_PATH   $LD_LIBRARY_PATH $CUDA_HOME/extras/CUPTI/lib64
  end
end

# --- FZF config
if test -e $HOME/.fzf/bin/fzf
  set -gx   FZF_FIND_FILE_COMMAND       "fd -L -t f -t l -t x . \$dir"
  set -gx   FZF_CD_COMMAND              "fd -L -t d . \$dir"
  set -gx   FZF_CD_WITH_HIDDEN_COMMAND  "fd -H -L -t d . \$dir"

  set -gx   FZF_DEFAULT_COMMAND         "fd -L ."
  set -gx   FZF_CTRL_T_COMMAND          "$FZF_DEFAULT_COMMAND"
  set -gx   FZF_ALT_C_COMMAND           "fd -L -t d ."

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

# --- Starfish setup (https://starship.rs)
if command -sq starship
  starship init fish | source
end

# -- Custom functions for productivity

function chpwd --on-variable PWD
    set -l cursor_pos (commandline --cursor)
    # Only show directory listing in interactive mode when not tab completing
    if test $cursor_pos -eq 0 ;and status --is-interactive
        ll
    end
end


