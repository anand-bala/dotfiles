" File: notetaking.vim
" Author: Anand Balakrishnan
" Description: Configuration for my notetaking extensions

" -- Spell check on for the following
augroup spellceck_ft_specific
    au!
    autocmd FileType tex,latex,markdown setlocal spell
augroup end

" -- Markdown {{
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_autowrite = 1
let g:vim_markdown_edit_url_in = 'vsplit'

let g:vim_markdown_math = 1
let g:vim_markdown_strikethrough = 1

let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_folding_disabled = 1
" }}

" -- TeX
" {{{

" }}}

" -- Zotero
" {{{
function! ZoteroCite()
  " pick a format based on the filetype (customize at will)
  let format = &filetype =~ '.*tex' ? 'cite' : 'pandoc'
  let api_call = 'curl -s http://127.0.0.1:23119/better-bibtex/cayw?format='.format
  execute 'read !'.api_call
endfunction
" }}}

