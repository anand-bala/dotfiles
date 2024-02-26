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

if command -sq -- eza
  alias ls "eza"
  alias ll "eza -l"
  alias tree "eza -l --tree"
else if command -sq -- exa
  alias ls "exa"
  alias ll "exa -l"
  alias tree "exa -l --tree"
end

alias less "less -R"
set -gx PAGER "less -R"
set -gx MANPAGER "less -R"

# --- Colorize GCC output
set -gx GCC_COLORS "error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01"

# --- FZF config
if test -e $HOME/.fzf/bin/fzf
  fish_add_path -gP $HOME/.fzf/bin/
end
set -gx FZF_DEFAULT_OPTS '--cycle --layout=reverse --border --height=90% --preview-window=wrap --marker="*"'

# --- NPM config
if not set -q NPM_CONFIG_PREFIX
  set -gx NPM_CONFIG_PREFIX ~/.local/lib/npm
end

# -- ROS stuff
set -gx COLCON_HOME $HOME/.config/colcon

if test -d $NPM_CONFIG_PREFIX
  fish_add_path -gP $NPM_CONFIG_PREFIX/bin
end

# --- Golang config
set -gx GOHOME   $HOME/go
fish_add_path -gP $GOHOME/bin

# --- Ruby config
if test -z "$GEM_HOME"
  set -gx GEM_HOME $HOME/gems
end

set -l gem_bin_path $GEM_HOME/bin

if test -d $gem_bin_path
  fish_add_path -gP $gem_bin_path
end

# -- Cargo/Rust config
if test -z "$CARGO_HOME"
  set -gx CARGO_HOME $HOME/.cargo
end

set -l rustup_path $CARGO_HOME/bin

if test -d $rustup_path
  fish_add_path -gP $rustup_path
end

# -- Tex Paths
if test -z "$TEXMFHOME"
  set -gx TEXMFHOME ~/texmf
end

if test -z "$TEXMFVAR"
  set -gx TEXMFVAR ~/.cache/texlive
end

# -- WSL stuff
if set -q WSL_DISTRO_NAME
  set -gx BROWSER wslview

  # set -l wslip (ip route | awk '/default via/' | cut -d" " -f3)
  # set -gx DISPLAY "$wslip:0.0"
  # set -gx LIBGL_ALWAYS_INDIRECT 1
end


# # --- CUDA config
# if not set -q CUDA_HOME; and test -d "/usr/local/cuda"
#   set -gx CUDA_HOME           /usr/local/cuda
# end

if set -q CUDA_HOME
  fish_add_path -gP   $CUDA_HOME/bin

  not contains -- "$CUDA_HOME/lib" $DYLD_LIBRARY_PATH;
    and set -gx DYLD_LIBRARY_PATH   $DYLD_LIBRARY_PATH $CUDA_HOME/lib

  not contains -- "$CUDA_HOME/lib64" $LD_LIBRARY_PATH;
    and set -gx LD_LIBRARY_PATH     $LD_LIBRARY_PATH $CUDA_HOME/lib64

  not contains -- "/usr/lib/nvidia" $LD_LIBRARY_PATH;
    and set -gx LD_LIBRARY_PATH     $LD_LIBRARY_PATH /usr/lib/nvidia

  if test -d $CUDA_HOME/extras/CUPTI/lib64
    not contains -- "$CUDA_HOME/extras/CUPTI/lib64" $LD_LIBRARY_PATH;
      and set -gx LD_LIBRARY_PATH   $LD_LIBRARY_PATH $CUDA_HOME/extras/CUPTI/lib64
  end

  if test -d $CUDA_HOME/targets/(uname -i)-linux/lib
    not contains == "$CUDA_HOME/targets/(uname -i)-linux/lib" $LD_LIBRARY_PATH;
      and set -gx LD_LIBRARY_PATH $LD_LIBRARY_PATH $CUDA_HOME/targets/(uname -i)-linux/lib
  end
end


# --- Conda configuration
set -gx MAMBA_ROOT_PREFIX "$HOME/.local/share/mamba"

if test -f $HOME/.local/share/mamba/bin/conda
  eval $HOME/.local/share/mamba/bin/conda "shell.fish" "hook" $argv | source
else
  if test -f "$HOME/.local/share/mamba/etc/fish/conf.d/conda.fish"
    source "$HOME/.local/share/mamba/etc/fish/conf.d/conda.fish"
  else
    fish_add_path -gP "$HOME/.local/share/mamba/bin"
  end
end

if test -f "$HOME/.local/share/mamba/etc/fish/conf.d/mamba.fish"
  source "$HOME/.local/share/mamba/etc/fish/conf.d/mamba.fish"
end

# --- Direnv config
if command -sq -- direnv 
  direnv hook fish | source
end

# --- Custom prompt (last plugin)
if command -sq -- starship
  set -gx STARSHIP_CONFIG $HOME/.config/starship/starship.toml
  starship init fish | source
end
