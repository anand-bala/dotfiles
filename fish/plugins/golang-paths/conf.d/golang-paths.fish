set -l golang_root /usr/local/go

if [ $GOROOT ]
  set -l golang_root $GOROOT
end

set -l go_binpath $golang_root/bin

contains -- $go_binpath $PATH
  or set -gx PATH $go_binpath $PATH
