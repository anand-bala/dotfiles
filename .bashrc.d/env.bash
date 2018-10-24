# Set Paths
# ------------------------------------------------------------d
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

if [ "$(uname)" == "Darwin" ]; then
  export PATH="$PATH:/opt/X11/bin:/Library/TeX/texbin"
fi

export PATH="$HOME/bin:$PATH"

# Set Default Editor
# ------------------------------------------------------------
export EDITOR=vim



# Dev Environmant
# ----------------------------

for f in ${HOME}/.paths.d/*; do
  source $f;
done


