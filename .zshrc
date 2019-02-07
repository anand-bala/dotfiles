#: Basic Configuration {
setopt appendhistory autocd nomatch autopushd pushdignoredups promptsubst
unsetopt beep
# bindkey -v
#: }


#: Common Shell stuff {
# Manipulate aliases
. ~/.shellrc/aliases.sh
# Manipulate PATH, etc
. ~/.shellrc/env.sh
# Add custom funcs here
fpath+=~/.zfunc
#: }

#: Custom stuff {
[ -f ~/.secretsconf ] && . ~/.secretsconf
[ -f ~/.fzf.zsh ] && . ~/.fzf.zsh
#: }

#: ANTIGEN!!!! {
source ~/.shellrc/zsh/antigen.zsh
antigen init ~/.shellrc/zsh/antigenrc
#: }

compinit



