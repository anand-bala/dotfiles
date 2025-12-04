function copy --description 'Copy to clipboard'
  if command -sq xclip
    xclip -selection clipboard $argv
  else
    rm -f /tmp/clipboard 2> /dev/null
    if [ $# -eq 0 ]; then
      cat > /tmp/clipboard
    else
      cat "$1" > /tmp/clipboard
    end
  end
end
