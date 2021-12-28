set -l luarocks_bin_path "$HOME/.luarocks/bin"

if test -d $luarocks_bin_path
  fish_add_path -gP $luarocks_bin_path
end
