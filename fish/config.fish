# -----------------------------------------------------------------------------
# Setup PATH from scratch
# -----------------------------------------------------------------------------

# Setup macOS specific paths
if test (uname) = "Darwin"
  set -x PATH $PATH /opt/X11/bin /Library/TeX/texbin
end

# Common directories to add, if they exist
for p in "$HOME/bin" "$HOME/.local/bin" "/snap/bin"
  if test -d $p
    set -x PATH $p $PATH
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

  set -gx   PATH  $HOME/.fzf/bin $PATH
end

# --- Golang config
if test -d /usr/local/go
  set -x GOROOT   /usr/local/go
  set -x GOHOME   $HOME/go
  set -gx PATH    $GOROOT/bin $GOHOME/bin $PATH
end

# --- Rust config
if test -e $HOME/.cargo/env
  set -gx PATH    $HOME/.cargo/bin $PATH
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


