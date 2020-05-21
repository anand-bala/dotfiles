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

let g:vimtex_fold_enabled = 0
let g:vimtex_format_enabled = 1
let g:vimtex_toc_config = {
      \ 'split_pos' : 'full',
      \ 'mode' : 2,
      \ 'fold_enable' : 1,
      \ 'hotkeys_enabled' : 1,
      \ 'hotkeys_leader' : '',
      \ 'refresh_always' : 0,
      \}
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_quickfix_autoclose_after_keystrokes = 3
let g:vimtex_mappings_enabled = 0
