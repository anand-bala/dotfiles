setlocal formatoptions+=t
setlocal textwidth=79

let g:vim_markdown_toc_autofit = 1

let g:vim_markdown_conceal = 1
let g:vim_markdown_math = 1
let g:vim_markdown_conceal_code_blocks = 0

let g:vim_markdown_new_list_item_indent = 4
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0

" ALE
" {{{
let b:ale_linters = ['proselint', 'vale', 'alex']
" }}}

