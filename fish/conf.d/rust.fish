if test -n "$CARGO_HOME"
  set rustup_path $CARGO_HOME/bin
else
  set -l rustup_path $HOME/.cargo/bin
end

if test -d $rustup_path
  set -gx CARGO_HOME $rustup_path
  fish_add_path -gP $rustup_path
end
