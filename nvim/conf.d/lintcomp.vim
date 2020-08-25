" File: lintcomp.vim
" Author: Anand Balakrishnan
" Description: Configuration for Linter and Autocomplete

" -- ALE config
" {{
let g:ale_set_signs = 1
let g:ale_set_highlights = 0
" Set ALE explicit so that I need to enable only the select few plugins I like
" in ALE (proselint, etc.)
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1

let g:ale_linters = {
      \ 'markdown' : ['proselint', 'vale', 'alex'],
      \ 'rst': ['proselint'],
      \ 'cmake': ['cmakelint'],
      \ 'python': ['mypy'],
      \ }

let g:ale_fixers = {
      \ 'javascript': ['eslint'],
      \ 'css': ['prettier'],
      \ 'scss': ['prettier'],
      \ 'html': ['prettier'],
      \ 'cpp': ['clang-format'],
      \ 'python': ['black', 'isort'],
      \ 'cmake': ['cmakeformat'],
      \ }
let g:ale_cmake_cmakeformat_executable = 'cmake-format'
let g:ale_cmake_cmakelint_executable = 'cmake-lint'

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

command! -nargs=0 Format ALEFix

" }}

" -- ctags settings
" {{
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+aimS',
      \ ]
let g:gutentags_file_list_command = {
      \ 'markers': {
      \   '.git': 'fd -L -t f',
      \   '.hg': 'fd -L -t f',
      \ },
      \}
" }}

" -- UltiSnips
" {{
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsExpandTrigger="jl"
let g:UltiSnipsJumpForwardTrigger="jl"
let g:UltiSnipsJumpBackwardTrigger="jh"
" }}

" -- Vista
" {{{
let g:vista_default_executive = 'ctags'
let g:vista_finder_alternative_executives = ['nvim_lsp', 'ale']
let g:vista_sidebar_width = 40
" }}}

" -- nvim-lsp completions-nvim diagnostics-nvim
" {{{
" Load default LSP configuration
" diagnostic-nvim
let g:diagnostic_enable_virtual_text = 0
let g:diagnostic_virtual_text_prefix = ' '
let g:diagnostic_trimmed_virtual_text = 30
let g:space_before_virtual_text = 5
let g:diagnostic_insert_delay = 1

" completion-nvim
let g:completion_enable_snippet = 'UltiSnips'
let g:completion_max_items = 10
let g:completion_enable_auto_paren = 0

augroup CompletionTriggerCharacter
  autocmd!
  autocmd BufEnter * let g:completion_trigger_character = ['.']
  autocmd FileType rust,cpp let g:completion_trigger_character = ['.', '::']
augroup end
" let g:completion_confirm_key = "\<TAB>"

let g:completion_auto_change_source = 1

lua require("lsp-config").setup()

command! LspShowLineDiagnostic lua vim.lsp.util.show_line_diagnostics()

" }}}

