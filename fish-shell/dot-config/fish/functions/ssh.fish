# Defined via `source`
function ssh --description 'alias ssh=TERM=xterm-256color ssh'
  TERM=xterm-256color command ssh $argv; 
end
