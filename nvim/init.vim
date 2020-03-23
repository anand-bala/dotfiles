" -- Shell Problems
if &shell =~# 'fish$'
  set shell=sh
endif

source conf.d/sane.vim

source conf.d/plugins.vim

" -- Filetype mappings

augroup ft_mappings
  au!
  autocmd BufRead,BufNewFile *.tex,*.latex  set filetype=tex
augroup end

source conf.d/lintcomp.vim
source conf.d/ui.vim
