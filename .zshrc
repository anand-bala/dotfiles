if [[ $(umask) == "000" ]]; then 
  umask 022 
fi

#: Basic Configuration {
autoload -Uz compinit
setopt appendhistory autocd nomatch autopushd pushdignoredups promptsubst
unsetopt beep

autoload -U compinit
# bindkey -v
#: }

#: ANTIGEN!!!! {
# We do antigen first because we let the plugins do their thing, and then
# perform custom alterations
source ~/.shellrc/zsh/antigen.zsh
antigen init ~/.shellrc/zsh/antigenrc
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

compinit


