" File: ui.vim
" Author: Anand Balakrishnan
" Description: Configuration for my UI

" Make the cursor vertically centered
augroup VCenterCursor
  au!
  au BufEnter,WinEnter,WinNew,VimResized *,*.*
        \ let &scrolloff=winheight(win_getid())/2
augroup END

" -- Lightline status line {{{
let g:lightline = {
      \ 'colorscheme': 'powerline',
      \ 'active': {
      \   'left':   [[ 'mode', 'paste' ],
      \              [ 'gitbranch', 'readonly', 'filename', 'modified' ],
      \              ],
      \   'right':  [[ 'lineinfo' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ],
      \              ],
      \ },
      \ 'component_function': {
      \   'gitbranch': 'MyGitBranch',
      \   'filetype': 'MyFiletype',
      \   'fileformat': 'MyFileformat',
      \ },
      \ }

function! MyGitBranch()
    return FugitiveHead() . ' '
endfunction

function! MyFiletype()
  return winwidth(0) > 50 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileformat()
  return winwidth(0) > 50 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

" }}}
" -- TMUX Line {{{
let g:tmuxline_powerline_separators = 0
let g:tmuxline_preset = {
      \'a'    : '#H',
      \'b'    : '#S',
      \'win'  : '#I #W',
      \'cwin' : '#I #W',
      \'x'    : '%a %b %d',
      \'y'    : '%r',
      \}
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
let g:LspDiagnosticsErrorSign = ' '
let g:LspDiagnosticsWarningSign = '⚡'
let g:LspDiagnosticsInformationSign = '✦ '
let g:LspDiagnosticsHintSign = ' '
" }}}
