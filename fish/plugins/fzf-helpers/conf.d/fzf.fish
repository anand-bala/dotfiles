set -gx FZF_DEFAULT_OPTS        "--cycle --layout=reverse --border --height 40%"
set -gx FZF_DEFAULT_COMMAND     "fd -L -t f ."
set -gx FZF_DIRECTORY_COMMAND   "fd -L -t d ."

bind \cf '__fzf_search_current_dir'
bind \co '__fzf_find_dir'
bind \cr '__fzf_search_history'
alias glg='__fzf_search_git_log'


