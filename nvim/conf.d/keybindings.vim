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
nmap <leader>ea= <Cmd>Tabularize /=<CR>
vmap <leader>ea= <Cmd>Tabularize /=<CR>
nmap <leader>ea: <Cmd>Tabularize /:\zs<CR>
vmap <leader>ea: <Cmd>Tabularize /:\zs<CR>
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

command! -bang -nargs=0 IMaps call fzf#vim#maps('i', 0)

" Search for Zotero references
nnoremap  <silent><C-z> :call ZoteroCite()<CR>
inoremap  <silent><C-z> <C-o>:call ZoteroCite()<CR>
" }}}

" -- nvim-lsp and ALE {{{
inoremap <silent> <C-p>         <Plug>(completion_trigger)

nnoremap <silent> K             <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <leader>gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader>gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> <leader>pd    <cmd>lua require'lsp_util'.peek_definition()<CR>
nnoremap <silent> <C-s>         <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> <leader>gw    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> <leader>f     <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>a     <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <leader>rn    <cmd>lua vim.lsp.buf.rename()<CR>

nnoremap <silent> <leader>ld    <cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>
nnoremap <silent> ]d            <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <silent> [d            <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> <leader>od    <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
" }}}

" -- TeX {{{
augroup tex_kb
  au!
  autocmd FileType tex,latex  :call <SID>tex_keybindings()
augroup end

function s:tex_keybindings()
  nmap <silent><buffer>   <leader>lv  <cmd>lua TexlabForwardSearch()<CR>
endfunction

" }}}


" -- Pop-Up Menu {{{

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~ '\s'
" endfunction

"  ESC to cancel
"  ENTER for accept
" inoremap <silent><expr> <Esc>     pumvisible() ? "\<C-e>" : "\<Esc>"
" inoremap <silent><expr> <CR>      pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-y>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ completion#trigger_completion()
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
