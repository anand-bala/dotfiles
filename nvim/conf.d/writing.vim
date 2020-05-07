" File: notetaking.vim
" Author: Anand Balakrishnan
" Description: Configuration for my notetaking extensions

" -- Spell check on for the following
augroup spellceck_ft_specific
    autocmd FileType tex,latex,markdown set spell
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
" Disable some chktex warnings
let g:ale_tex_chktex_options = '-n3 -I'

let g:tex_stylish = 1
let g:tex_conceal = ''
let g:tex_flavor = 'latex'
let g:tex_isk='48-57,a-z,A-Z,192-255,:'

let g:vimtex_fold_enabled = 0
let g:vimtex_fold_types = {
      \ 'markers' : {'enabled': 0},
      \ 'sections' : {'parse_levels': 1},
      \}
let g:vimtex_format_enabled = 1
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_automatic = 0
let g:vimtex_view_forward_search_on_start = 0
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
let g:vimtex_complete_img_use_tail = 1
let g:vimtex_complete_bib = {
      \ 'simple' : 1,
      \ 'menu_fmt' : '@title, @author_short, @year',
      \}
let g:vimtex_echo_verbose_input = 0
let g:vimtex_compiler_progname='nvr'

if has('win32') || (has('unix') && exists('$WSLENV'))
  if executable('SumatraPDF.exe')
    let g:vimtex_view_general_viewer = 'SumatraPDF.exe'
  elseif executable('mupdf.exe')
    let g:vimtex_view_general_viewer = 'mupdf.exe'
  endif
elseif has('unix')
  let g:vimtex_view_method = 'zathura'
endif
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

