#!/usr/bin/env fish

# This script sets up the path for GEM_HOME at $HOME/gems

test -n "$GEM_HOME" # True if $GEM_HOME is filled
or set -gx GEM_HOME $HOME/gems

set -l gem_bin_path $GEM_HOME/bin

if test -d $gem_bin_path
  contains -- $gem_bin_path $PATH # True if $PATH contains $GEM_HOME/bin
  or set -gx PATH $gem_bin_path $PATH
end

set -l name (basename (status -f) .fish){_uninstall}

function $name -e $name
  set -l i (contains -i -- $gem_bin_path $PATH)
  and set -e PATH[$i]
end

