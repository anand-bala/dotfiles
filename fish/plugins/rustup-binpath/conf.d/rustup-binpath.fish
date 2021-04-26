set -l rustup_path $HOME/.cargo/bin

if [ $CARGO_HOME ]
  set rustup_path $CARGO_HOME/bin
end

if test -d $rustup_path
  contains -- $rustup_path $PATH
  or set -gx PATH $rustup_path $PATH
end
