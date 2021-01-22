function gdb-tmux -d "create a gdb dashboard session using tmux."
    set -l id (tmux split-pane -hPF "#D" "tail -f /dev/null")
    tmux last-pane
    set -l tty (tmux display-message -p -t "$id" '#{pane_tty}')
    gdb -ex "dashboard -output $tty" "$argv"
    tmux kill-pane -t "$id"
end
