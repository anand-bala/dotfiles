if test -n "$GOROOT"
  set -l golang_root $GOROOT
else
  set -l golang_root /usr/local/go
end

set -l go_binpath $golang_root/bin

if test -d $go_binpath
  fish_add_path $go_binpath
end
