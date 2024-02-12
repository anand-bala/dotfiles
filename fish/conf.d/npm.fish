if not set -q NPM_CONFIG_PREFIX
  set -gx NPM_CONFIG_PREFIX ~/.local/lib/npm
end

if test -d $NPM_CONFIG_PREFIX
  fish_add_path -gmpP $NPM_CONFIG_PREFIX/bin
end
