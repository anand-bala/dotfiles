function tm -d "create new tmux session, or switch to existing one. Works from within tmux too."
  test -n "$TMUX"; # Check if we are in a TMUX session
  and set -l change "switch-client"; # If YES: We are switching session.
  or set -l change "attach-session"; # Else: We are trying to attach to one.

  if test (count $argv) -ge 1
    echo "Trying to attach to session:" $argv[1]
    tmux $change -t $argv[1] 2>/dev/null;
    or begin tmux new-session -d -s $argv[1]; and tmux $change -t $argv[1]; end
  else
    echo "Here are a list"
    set -l session (tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0);
    and tmux $change -t $session;
    or echo "No session found";
  end
end
