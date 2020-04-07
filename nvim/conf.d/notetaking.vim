" File: notetaking.vim
" Author: Anand Balakrishnan
" Description: Configuration for my notetaking extensions

" -- Pandoc {{{
let g:pandoc#keyboard#use_default_mappings = 0
let g:pandoc#filetypes#handled = ["pandoc", "markdown"]
let g:pandoc#filetypes#pandoc_markdown = 0
let g:pandoc#syntax#conceal#use = 0
" }}}

" -- Goyo {{{
let g:goyo_width = 85
let g:goyo_height = '95%'
" }}}

