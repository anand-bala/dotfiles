# -----------------------------------------------------------------------------
# Setup PATH from scratch
# -----------------------------------------------------------------------------

# Setup macOS specific paths
if test (uname) = "Darwin"
  set -x PATH $PATH /opt/X11/bin /Library/TeX/texbin
end

# Common directories to add, if they exist
for p in "$HOME/bin" "$HOME/.local/bin" "/snap/bin"
  if test -d $p
    set -x PATH $p $PATH
  end
end

if type -q nvim
  set -gx EDITOR nvim
else
  set -gx EDITOR vim
end




