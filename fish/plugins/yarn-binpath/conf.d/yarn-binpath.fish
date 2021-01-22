set -l yarn_bin_path (yarn global bin)

contains -- $yarn_bin_path $PATH
  or set -gx PATH $yarn_bin_path $PATH
