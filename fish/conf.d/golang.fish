# --- Golang config
if test -d /usr/local/go
  set -x GOROOT   /usr/local/go
  set -x GOHOME   $HOME/go
end

if test -n "$GOROOT"
  set -l golang_root $GOROOT
else
  set -l golang_root /usr/local/go
end

set -l go_binpath $golang_root/bin

if test -d $go_binpath
  fish_add_path -gP $go_binpath
end

if test -d $GOHOME/bin
  fish_add_path -gP $GOHOME/bin
end
