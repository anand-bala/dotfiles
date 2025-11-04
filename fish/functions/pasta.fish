function pasta --description 'Output from clipboard'
  if command -sq xclip
    xclip -sel clipboard -o
  else if test -f /tmp/clipboard
    cat /tmp/clipboard
  end
end
