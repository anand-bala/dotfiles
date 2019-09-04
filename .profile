case $- in
  *i*)
    # Interactive session. Try switching to bash.
    if [ -z "$ZSH" ]; then # do nothing if running under bash already
      bash=$(command -v zsh)
      if [ -x "$bash" ]; then
        export SHELL="$bash"
        exec "$bash"
      fi
    fi
esac

