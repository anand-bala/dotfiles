" File: lintcomp.vim
" Author: Anand Balakrishnan
" Description: Configuration for Linter and Autocomplete

" -- ctags settings
" {{
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+aimS',
      \ ]
let g:gutentags_file_list_command = {
      \ 'markers': {
      \   '.latexmkrc': 'fd -L -t f',
      \   '.git': 'fd -L -t f',
      \   '.hg': 'fd -L -t f',
      \ },
      \}
" }}

" -- UltiSnips
" {{
let g:UltiSnipsEditSplit="vertical"
" }}

" -- nvim-lsp, ALE, and neoformat
" {{{
" ALE
let g:ale_set_signs = 1
let g:ale_set_highlights = 0
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1
let g:ale_set_loclist=0
let g:ale_set_quickfix=0

let g:ale_linters = {}
let g:ale_fixers = {}

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s'


" LSP
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_max_items = 10
let g:completion_enable_auto_paren = 0
let g:completion_timer_cycle = 200 "default value is 80

augroup CompletionTriggerCharacter
  autocmd!
  autocmd BufEnter * let g:completion_trigger_character = ['.']
  autocmd FileType rust,cpp let g:completion_trigger_character = ['.', '::']
augroup end

let g:completion_auto_change_source = 1

lua require("lsp-config").setup()

" }}}

lua require("ts-config")
