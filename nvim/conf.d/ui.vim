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
      \   'left':   [[ 'mode', 'paste', 'session' ],
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
      \   'filename' : 'MyFilename',
      \   'session': 'ObsessionStatus'
      \ },
      \ }

function! MyGitBranch()
  return FugitiveHead() . ' '
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

function! MyFilename()
  return expand('%')
endfunction

" }}}

" -- FZF
" {{{
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
" }}}

" -- Fern
" {{{
let g:fern#renderer = "nerdfont"
augroup fern_ui 
  autocmd FileType fern setlocal nonumber norelativenumber statusline=%F
augroup end

" }}}

" -- LSP and ALE
" {{{

let g:ale_sign_error = ""
let g:ale_sign_warning = "⚡"
let g:ale_sign_info = "✦"
call ale#sign#Clear()
sign define ALEErrorSign text= texthl=LspDiagnosticsSignError linehl= numhl=
sign define ALEWarningSign text=⚡ texthl=LspDiagnosticsSignWarning linehl= numhl=
sign define ALEInformationSign text=✦ texthl=LspDiagnosticsSignInformation linehl= numhl=


sign define LspDiagnosticsSignError text= texthl=LspDiagnosticsSignError linehl= numhl=
sign define LspDiagnosticsSignWarning text=⚡ texthl=LspDiagnosticsSignWarning linehl= numhl=
sign define LspDiagnosticsSignInformation text=✦ texthl=LspDiagnosticsSignInformation linehl= numhl=
sign define LspDiagnosticsSignHint text= texthl=LspDiagnosticsSignHint linehl= numhl=

" }}}
