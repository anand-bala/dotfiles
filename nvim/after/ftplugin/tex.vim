let b:dispatch = 'latexmk -pdf -pvc'
compiler latexmk

setlocal formatoptions+=t
setlocal textwidth=79

" ALE
" {{{
let b:ale_linters = ['proselint', 'lacheck', 'textidote']
" Disable some chktex warnings
let g:ale_tex_chktex_options = '-n3 -I'
let b:ale_fixers = ['remove_trailing_lines', 'trim_whitespace']

" }}}
let g:tex_conceal="abdgm"
let g:tex_flavor = 'latex'
