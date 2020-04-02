" File: notetaking.vim
" Author: Anand Balakrishnan
" Description: Configuration for my notetaking extensions

" -- Pandoc {{{
let g:pandoc#keyboard#use_default_mappings = 0
let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
let g:pandoc#filetypes#pandoc_markdown = 0
let g:pandoc#syntax#conceal#use = 0
" }}}

" -- Pencil {{{
let g:pencil#wrapModeDefault = 'soft'   " default is 'hard'

augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init()
  autocmd FileType text         call pencil#init({'wrap': 'hard'})
augroup END
" }}}
