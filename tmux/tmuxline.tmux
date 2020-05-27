# This tmux statusbar config was created by tmuxline.vim
# on Tue, 07 Apr 2020

set -g status-justify "centre"
set -g status "on"
set -g status-left-style "none"
set -g message-command-style "fg=colour231,bg=colour31"
set -g status-right-style "none"
set -g pane-active-border-style "fg=colour254"
set -g status-style "none,bg=colour234"
set -g message-style "fg=colour231,bg=colour31"
set -g pane-border-style "fg=colour240"
set -g status-right-length "100"
set -g status-left-length "100"
setw -g window-status-activity-style "underscore,fg=colour250,bg=colour234"
setw -g window-status-separator ""
setw -g window-status-style "none,fg=colour250,bg=colour234"
set -g status-left "#[fg=colour16,bg=colour254,bold] #H #[fg=colour254,bg=colour240,nobold,nounderscore,noitalics]#[fg=colour237,bg=colour240] #S #[fg=colour240,bg=colour234,nobold,nounderscore,noitalics]"
set -g status-right "#[fg=colour232,bg=colour234,nobold,nounderscore,noitalics]#[fg=colour250,bg=colour232] %a %b %d #[fg=colour236,bg=colour232,nobold,nounderscore,noitalics]#[fg=colour247,bg=colour236] %r "
setw -g window-status-format "#[fg=colour234,bg=colour234,nobold,nounderscore,noitalics]#[default] #I #W #[fg=colour234,bg=colour234,nobold,nounderscore,noitalics]"
setw -g window-status-current-format "#[fg=colour234,bg=colour31,nobold,nounderscore,noitalics]#[fg=colour231,bg=colour31,bold] #I #W #[fg=colour31,bg=colour234,nobold,nounderscore,noitalics]"
