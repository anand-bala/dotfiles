# COLORS!
# ------------------------------------------------------------
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# Set Paths
# ------------------------------------------------------------d
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

if [ "$(uname)" = "Darwin" ]; then
  export PATH="$PATH:/opt/X11/bin:/Library/TeX/texbin"
fi

if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "/snap/bin" ]; then
  export PATH="$PATH:/snap/bin"
fi

# Set Default Editor
export EDITOR=vim

for f in $HOME/.shellrc/paths/* ; do
  . $f
done

