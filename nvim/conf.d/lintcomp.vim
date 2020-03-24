" File: lintcomp.vim
" Author: Anand Balakrishnan
" Description: Configuration for Linter and Autocomplete

" -- ALE config
" {{
let g:ale_set_signs = 1
let g:ale_set_highlights = 1

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_delay = 0

let g:ale_linters = {
      \ 'tex': [],
      \ 'python': [],
      \ 'rust': [],
      \}
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

nmap <silent> <leader>aa <Plug>(ale_lint)
nmap <silent> <leader>ln <Plug>(ale_next_wrap)
nmap <silent> <leader>lp <Plug>(ale_previous_wrap)
" }}

" -- coc.nvim config
" {{
let g:coc_global_extensions = [
      \ 'coc-actions',
      \ 'coc-word',
      \ 'coc-snippets',
      \ 'coc-yaml',
      \ 'coc-json',
      \ 'coc-rls',
      \ 'coc-python'
      \]

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

imap <silent> <c-u>      <plug>(coc-snippets-expand)

nmap <silent> <leader>ld <plug>(coc-definition)
nmap <silent> <leader>lt <plug>(coc-type-definition)
nmap <silent> <leader>li <plug>(coc-implementation)
nmap <silent> <leader>lf <plug>(coc-references)
nmap          <leader>lr <plug>(coc-rename)

" Use ALE for diagnostics
" nmap <silent> <leader>lp <plug>(coc-diagnostic-prev)
" nmap <silent> <leader>ln <plug>(coc-diagnostic-next)

" Formatting selected code.
xmap <leader>gf  <Plug>(coc-format-selected)
nmap <leader>gf  <Plug>(coc-format-selected)

nnoremap <silent> K :call <sid>show_documentation()<cr>
command! -nargs=0 Format :call CocAction('format')

function! s:show_documentation()
  if index(['vim','help'], &filetype) >= 0
    execute 'help ' . expand('<cword>')
  elseif &filetype ==# 'tex'
    VimtexDocPackage
  else
    call CocAction('doHover')
  endif
endfunction

if exists('*CocActionAsync')
  augroup coc_settings
    autocmd!
    autocmd CursorHold * silent call CocActionAsync('highlight')
  augroup END
endif
" }}

" -- ctags settings
" {{
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+aimS',
      \ ]
let g:gutentags_file_list_command = {
      \ 'markers': {
      \   '.git': 'git ls-files',
      \   '.hg': 'hg files',
      \ },
      \}
" }}
