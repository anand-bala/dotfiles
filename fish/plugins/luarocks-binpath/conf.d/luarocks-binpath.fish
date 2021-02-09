set -l luarocks_bin_path "$HOME/.luarocks/bin"

if test -d $luarocks_bin_path
  contains -- $luarocks_bin_path $PATH
    or set -gx PATH $luarocks_bin_path $PATH
end
