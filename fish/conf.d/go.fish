
if test -d /usr/local/go
  set -x GOROOT   /usr/local/go
  set -x GOHOME   $HOME/go
  set -gx PATH    $GOROOT/bin $GOHOME/bin $PATH
end
