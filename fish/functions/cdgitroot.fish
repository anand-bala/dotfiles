function cdgitroot -d "Change directory to the git root repo"
  set -l git_toplevel (git rev-parse --show-toplevel 2> /dev/null)
  set -l cmd_status $status
  if test $cmd_status -ne 0
    echo "Looks like you're not in a git repository" 2>&1
  else
    echo Changing directory to $git_toplevel
    cd $git_toplevel
  end
end
