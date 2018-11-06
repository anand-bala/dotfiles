#: Basic Configuration {
setopt appendhistory autocd nomatch autopushd pushdignoredups promptsubst
unsetopt beep
# bindkey -v
#: }

#: ANTIGEN!!!! {
source ~/.shellrc/zsh/antigen.zsh
antigen init ~/.shellrc/zsh/antigenrc
#: }

#: Common Shell stuff {
# Manipulate aliases
. ~/.shellrc/aliases.sh
# Manipulate PATH, etc
. ~/.shellrc/env.sh
#: }

#: Custom stuff {
[ -f ~/.secretsconf ] && . ~/.secretsconf
[ -f ~/.fzf.zsh ] && . ~/.fzf.zsh
#: }


