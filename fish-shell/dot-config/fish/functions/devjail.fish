function devjail -d "Run the given command in a firejail, whitelisting current directory"
  if command -sq -- firejail
    set -l cwd (pwd -P)
    if test -n "$cwd"
      firejail --read-write="$cwd" --private-cwd="$cwd" --whitelist="$cwd" $argv
    else
      firejail $argv
    end
  else
    $argv
  end
end
