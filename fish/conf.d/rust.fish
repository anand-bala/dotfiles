if test -z "$CARGO_HOME"
  set -gx CARGO_HOME $HOME/.cargo
end

set -l rustup_path $CARGO_HOME/bin

if test -d $rustup_path
  fish_add_path -gmpP $rustup_path
end
