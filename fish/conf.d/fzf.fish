
if test -x $HOME/.fzf/bin/fzf
  set -gx FZF_FIND_FILE_COMMAND       "fd -L -t f -t l -t x . \$dir"
  set -gx FZF_CD_COMMAND              "fd -L -t d . \$dir"
  set -gx FZF_CD_WITH_HIDDEN_COMMAND  "fd -H -L -t d . \$dir"

  set -gx PATH $PATH $HOME/.fzf/bin
end

