" -- Shell Problems
if &shell =~# 'fish$'
  set shell=sh
endif

runtime conf.d/sane.vim

runtime conf.d/plugins.vim

" -- Filetype mappings

augroup ft_mappings
  au!
  autocmd BufRead,BufNewFile *.tex,*.latex  set filetype=tex
augroup end

runtime conf.d/lintcomp.vim
runtime conf.d/ui.vim
