" File: lintcomp.vim
" Author: Anand Balakrishnan
" Description: Configuration for Linter and Autocomplete

" -- ALE config
" {{
let g:ale_set_signs = 1
let g:ale_set_highlights = 0

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

" -- nvim-lsp completions-nvim diagnostics-nvim
" {{{
" lua require'nvim_lsp'.ccls.setup{on_attach=require'on_attach'.on_attach}
" au Filetype c,cpp setl omnifunc=v:lua.vim.lsp.omnifunc
" lua require'nvim_lsp'.pyls_ms.setup{on_attach=require'on_attach'.on_attach}
" au Filetype python setl omnifunc=v:lua.vim.lsp.omnifunc
" lua require'nvim_lsp'.rust_analyzer.setup{on_attach=require'on_attach'.on_attach}
" au Filetype rust setl omnifunc=v:lua.vim.lsp.omnifunc
" lua require'nvim_lsp'.texlab.setup{on_attach=require'on_attach'.on_attach}
" au Filetype tex,latex setl omnifunc=v:lua.vim.lsp.omnifunc

" let g:completion_chain_complete_list = {
            " \ 'default' : {
            " \   'default': [
            " \       {'complete_items': ['lsp', 'snippet']},
            " \       {'mode': '<c-p>'},
            " \       {'mode': '<c-n>'}],
            " \   'comment': [],
            " \   'string' : [
            " \       {'complete_items': ['path']}]
            " \   },
            " \ 'markdown' : {
            " \   'default': [
            " \       {'mode': 'spel'}],
            " \   'comment': [],
            " \   },
            " \ 'verilog' : {
            " \   'default': [
            " \       {'complete_items': ['ts']},
            " \       {'mode': '<c-p>'},
            " \       {'mode': '<c-n>'}],
            " \   'comment': [],
            " \   }
            " \}
" " autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()
" " autocmd CursorMoved * lua vim.lsp.util.show_line_diagnostics()

" let g:LspDiagnosticsErrorSign = ' '
" let g:LspDiagnosticsWarningSign = '⚡'
" let g:LspDiagnosticsInformationSign = 'I'
" let g:LspDiagnosticsHintSign = 'H'

" " diagnostic-nvim
" let g:diagnostic_enable_virtual_text = 0
" let g:diagnostic_virtual_text_prefix = ' '
" let g:diagnostic_trimmed_virtual_text = 30
" let g:space_before_virtual_text = 5
" let g:diagnostic_insert_delay = 1

" " completion-nvim
" let g:completion_enable_snippet = 'UltiSnips'
" let g:completion_max_items = 10
" let g:completion_enable_auto_paren = 1
" let g:completion_timer_cycle = 200


" }}}

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
