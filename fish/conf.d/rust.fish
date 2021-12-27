if test -n "$CARGO_HOME"
  set rustup_path $CARGO_HOME/bin
else
  set -l rustup_path $HOME/.cargo/bin
end

if test -d $rustup_path
  fish_add_path $rustup_path
end
