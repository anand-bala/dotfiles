let b:dispatch = 'latexmk -pdf -pvc'
compiler latexmk

" ALE
" {{{
let b:ale_linters = ['proselint', 'lacheck', 'chktex', 'textidote']
" Disable some chktex warnings
let g:ale_tex_chktex_options = '-n3 -I'
" }}}

let g:tex_stylish = 1
let g:tex_conceal = ''
let g:tex_flavor = 'latex'
let g:tex_isk='48-57,a-z,A-Z,192-255,:'

