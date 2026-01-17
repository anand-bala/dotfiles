function devjail -d "Run the given command in a firejail, whitelisting current directory"
  if command -sq -- firejail
    firejail --whitelist=$PWD $argv
  else
    $argv
  end
end
