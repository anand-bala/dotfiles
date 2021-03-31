if not set -q NPM_CONFIG_PREFIX
  set -gx NPM_CONFIG_PREFIX ~/.local/lib/npm
end

contains -- "$NPM_CONFIG_PREFIX/bin" $PATH
  or set -gx PATH   $NPM_CONFIG_PREFIX/bin $PATH
