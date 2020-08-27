" File: ui.vim
" Author: Anand Balakrishnan
" Description: Configuration for my UI

" Make the cursor vertically centered
augroup VCenterCursor
    au!
    au BufEnter,WinEnter,WinNew,VimResized *,*.*
                \ let &scrolloff=winheight(win_getid())/2
augroup END

" -- NERDTree
" {{{
augroup nerdtree_config
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup end
" }}}

" -- Lightline status line {{{
let g:lightline = {
            \ 'colorscheme': 'powerline',
            \ 'active': {
            \   'left':   [[ 'mode', 'paste' ],
            \              [ 'gitbranch', 'readonly', 'filename', 'modified' ],
            \              [ 'lspstatus' ],
            \              ],
            \   'right':  [[ 'lineinfo' ],
            \              [ 'fileformat', 'fileencoding', 'filetype' ],
            \              ],
            \ },
            \ 'component_function': {
            \   'gitbranch': 'MyGitBranch',
            \   'filetype': 'MyFiletype',
            \   'fileformat': 'MyFileformat',
            \   'filename' : 'MyFilename',
            \   'lspstatus' : 'LspStatus',
            \ },
            \ }

function! MyGitBranch()
    return FugitiveHead() . ' '
endfunction

function! MyFileformat()
  return winwidth(0) > 50 ? &fileformat : ''
endfunction

function! MyFiletype()
    return winwidth(0) > 50 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFilename()
    return expand('%')
endfunction

function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

" }}}

" -- Matchup {{{

augroup matchup_matchparen_highlight
    au!
    au BufRead,BufNewFile,ColorScheme * hi MatchParen ctermbg=lightgray ctermfg=black guibg=lightgray guifg=black
    au BufRead,BufNewFile,ColorScheme * hi MatchWord cterm=underline gui=underline
augroup end

let g:matchup_matchparen_fallback = 0

" }}}

" -- FZF
" {{{
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" }}}

" -- LSP
" {{{
call sign_define("LspDiagnosticsErrorSign", {"text" : " ", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "⚡", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticInformationSign", {"text" : "✦ ", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticHintSign", {"text" : " ", "texthl" : "LspDiagnosticsHint"})

" }}}
