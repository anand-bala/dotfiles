" File: lintcomp.vim
" Author: Anand Balakrishnan
" Description: Configuration for Linter and Autocomplete

" -- ALE config
" {{
let g:ale_set_signs = 1
let g:ale_set_highlights = 1

let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 1
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_delay = 200

let g:ale_linters = {
      \ 'tex': [],
      \ 'python': [],
      \ 'rust': [],
      \ 'javascript': [],
      \ }

let g:ale_fixers = {
      \ 'javascript': ['eslint'],
      \ 'haskell': ['hindent', 'stylish-haskell'],
      \ }

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" }}

" -- coc.nvim config
" {{

if exists('*CocActionAsync')
  augroup coc_settings
    autocmd!
    autocmd CursorHold * silent call CocActionAsync('highlight')
  augroup END
endif
" }}

" -- ctags settings
" {{
" let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
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
