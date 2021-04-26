set -l home_bin_path "$HOME/.bin"

if test -d $home_bin_path
  contains -- $home_bin_path $PATH
  or set -gx PATH $home_bin_path $PATH
end
