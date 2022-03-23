# --- Golang config
if test -d /usr/local/go
  set -x GOROOT   /usr/local/go
  set -x GOHOME   $HOME/go
end

fish_add_path -gP $GOROOT/bin
fish_add_path -gP $GOHOME/bin

