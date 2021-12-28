# This script sets up the path for GEM_HOME at $HOME/gems

if test -z "$GEM_HOME"
  set -gx GEM_HOME $HOME/gems
end

set -l gem_bin_path $GEM_HOME/bin

if test -d $gem_bin_path
  fish_add_path -gP $gem_bin_path
end
