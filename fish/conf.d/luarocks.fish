set -l luarocks_bin_path "$HOME/.luarocks/bin"

if test -d $luarocks_bin_path
  fish_add_path $luarocks_bin_path
end
