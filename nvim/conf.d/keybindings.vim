" File: keybindings.vim
" Author: Anand Balakrishnan
" Description: Custom keybindings for various plugins

" -- Sanity stuff
" {{{

" shifting visual block should keep it selected
vnoremap < <gv
vnoremap > >gv|

" go up/down onw visual line
nnoremap <Down> gj
nnoremap <Up>   gk
vnoremap <Down> gj
vnoremap <Up>   gk
inoremap <Down> <C-o>gj
inoremap <Up>   <C-o>gk
" }}}

" -- Tabular {{{
nmap <leader>a= <Cmd>Tabularize /=<CR>
vmap <leader>a= <Cmd>Tabularize /=<CR>
nmap <leader>a: <Cmd>Tabularize /:\zs<CR>
vmap <leader>a: <Cmd>Tabularize /:\zs<CR>
" }}}

" -- Searching stuff {{

command! -bang -nargs=? -complete=dir Files
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:70%'), <bang>0)

command! -bang -nargs=? -complete=dir GFiles
      \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('right:70%'), <bang>0)

command! -bang -nargs=* Rg
      \ call fzf#vim#grep(
      \   'rg --max-columns=80 --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 2,
      \   fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:60%'),  <bang>0)

nnoremap <C-f> :Files<Cr>
nnoremap <C-g> :Rg<Cr>
vnoremap <C-g> y:Rg <C-R>"<CR>
nmap     <C-s> :Vista finder fzf:nvim_lsp<CR>

command! -bang -nargs=0 IMaps call fzf#vim#maps('i', 0)

" Search for Zotero references
nnoremap  <silent><C-z> :call ZoteroCite()<CR>
inoremap  <silent><C-z> <C-o>:call ZoteroCite()<CR>

" }}}

" -- Fern {{{
nnoremap <silent><C-n> <Cmd>Fern . -drawer -keep -toggle<CR>
" }}}

" -- nvim-lsp and ALE {{{
" let g:completion_confirm_key = "\<C-y>"
augroup lsp_kb
  au!
  autocmd BufRead,BufEnter *  :call <SID>lsp_keybindings()
augroup end

function s:lsp_keybindings()
  nnoremap <silent> <leader>gd          <cmd>lua vim.lsp.buf.definition()<CR>
  " nnoremap <silent> gr          <cmd>lua vim.lsp.buf.references()<CR>
  " nnoremap <silent> pd          <cmd>lua vim.lsp.buf.peek_definition()<CR>
  " nnoremap <silent> g0          <cmd>lua vim.lsp.buf.document_symbol()<CR>
  nnoremap <silent> <leader>ld  <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>

  nnoremap <silent>   K           <Plug>(nvim-lsp-hover)
  nnoremap <silent> <leader>d   <cmd>NextDiagnostic<CR>
  nnoremap <silent> <leader>pd  <cmd>PrevDiagnostic<CR>
  nnoremap <silent> <leader>od  <cmd>OpenDiagnostic<CR>
endfunction
" }}}

" -- TeX {{{
augroup tex_kb
  au!
  autocmd FileType tex,latex  :call <SID>tex_keybindings()
augroup end

function s:tex_keybindings()
  nmap <silent><buffer>   <leader>lv  <cmd>lua TexlabForwardSearch()<CR>
  " nmap <silent><buffer>   <C-s>       :call vimtex#fzf#run('ctli', g:fzf_layout)<cr>
endfunction

" }}}

" -- Julia {{{
augroup julia_kb
  au!
  autocmd FileType julia  :call <SID>julia_keybindings()
augroup end

function s:julia_keybindings()
  nnoremap <leader>f <cmd>call JuliaFormatter#Format(0)<CR>
  vnoremap <leader>f <cmd>call JuliaFormatter#Format(1)<CR>
endfunction

" }}}


" -- Pop-Up Menu {{{

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

"  Tab to scroll (SHIFT+Tab for backward scroll)
"  ESC to cancel
"  ENTER for accept
inoremap <silent><expr> <Esc>     pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <silent><expr> <CR>      pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-y>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ completion#trigger_completion()
" }}}

" -- Vim Help
" {{{
"The following mappings simplify navigation when viewing help:

"- Press Enter to jump to the subject (topic) under the cursor.
"- Press Backspace to return from the last jump.
"- Press s to find the next subject, or S to find the previous subject.
"- Press o to find the next option, or O to find the previous option. 

augroup vim_help_kb
  " this one is which you're most likely to use?
  autocmd FileType help   :call <SID>help_keybindings()
augroup end

function! s:help_keybindings()
  nnoremap <buffer> <CR> <C-]>
  nnoremap <buffer> o /'\l\{2,\}'<CR>
  nnoremap <buffer> O ?'\l\{2,\}'<CR>
  nnoremap <buffer> s /\|\zs\S\+\ze\|<CR>
  nnoremap <buffer> S ?\|\zs\S\+\ze\|<CR>
endfunction

" }}}

" -- 
