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
" let g:UltiSnipsExpandTrigger="jl"
" let g:UltiSnipsJumpForwardTrigger="\<TAB>"
" let g:UltiSnipsJumpBackwardTrigger="\<TAB>"
" }}

" -- Vista
" {{{
let g:vista_default_executive = 'ctags'
let g:vista_finder_alternative_executives = ['nvim_lsp', 'ale']
let g:vista_sidebar_width = 40
" }}}


" -- nvim-lsp and ALE
" {{{
" ALE
let g:ale_set_signs = 1
let g:ale_set_highlights = 0
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1
let g:ale_set_loclist=0
let g:ale_set_quickfix=0

let g:ale_linters = {
      \ 'cmake': ['cmakelint'],
      \ }

let g:ale_fixers = {
      \ 'cmake': ['cmakeformat'],
      \ }
let g:ale_cmake_cmakeformat_executable = 'cmake-format'
let g:ale_cmake_cmakelint_executable = 'cmake-lint'

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s'

command! -nargs=0 Format ALEFix


" completion-nvim
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

function! s:fix_ale_list(buffer, list) abort
    let l:format = g:ale_echo_msg_format
    let l:new_list = []

    for l:item in a:list
        let l:fixed_item = copy(l:item)

        let l:fixed_item.text = ale#GetLocItemMessage(l:item, l:format)

        if l:item.bufnr == -1
            " If the buffer number is invalid, remove it.
            call remove(l:fixed_item, 'bufnr')
        endif

        call add(l:new_list, l:fixed_item)
    endfor

    return l:new_list
endfunction

function s:update_diagnostics()
  let l:bfnum = bufnr()
  let l:lsp_loclist = luaeval("require(\"lsp-config\").get_loclist()")
  let l:ale_loclist = ale#engine#GetLoclist(l:bfnum)
  let l:ale_items = s:fix_ale_list(l:bfnum, l:ale_loclist)
  let l:list = l:lsp_loclist + l:ale_items

  call sort(l:list, function('ale#util#LocItemCompareWithText'))
  call uniq(l:list, function('ale#util#LocItemCompareWithText'))
  call setloclist(0, [], 'r', {'items': l:list, 'title': 'Diagnostics'})
endfunction

function! GetDiagnostics()
  let l:bfnum = bufnr()
  let l:lsp_loclist = luaeval("require(\"lsp-config\").get_loclist()")
  let l:ale_loclist = ale#engine#GetLoclist(l:bfnum)
  let l:ale_items = s:fix_ale_list(l:bfnum, l:ale_loclist)
  let l:items = l:lsp_loclist + l:ale_items
  call sort(l:items, function("ale#util#LocItemCompare"))
  return l:items
endfunction

function s:open_diagnostics()
  call s:update_diagnostics()
  lopen
  wincmd p
endfunction

augroup LintProgress
  autocmd!
  autocmd User ALELintPost,LSPDiagnosticsChanged call <SID>update_diagnostics()
augroup end

command! -bang -nargs=0 Diagnostics call <SID>open_diagnostics()
" }}}

lua require("ts-config")
