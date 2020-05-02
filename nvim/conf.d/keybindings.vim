" File: keybindings.vim
" Author: Anand Balakrishnan
" Description: Custom keybindings for various plugins

" -- Sanity stuff
" {{{

" shifting visual block should keep it selected
vnoremap < <gv
vnoremap > >gv|

" go up/down onw visual line
nnoremap j      gj
nnoremap k      gk
vnoremap j      gj
vnoremap k      gk
nnoremap <Down> gj
nnoremap <Up>   gk
vnoremap <Down> gj
vnoremap <Up>   gk
inoremap <Down> <C-o>gj
inoremap <Up>   <C-o>gk
" }}}

" -- EasyAlign {{{
nmap ea <plug>(LiveEasyAlign)
vmap ea <plug>(LiveEasyAlign)
nmap eA <plug>(EasyAlign)
vmap eA <plug>(EasyAlign)
vmap .  <plug>(EasyAlignRepeat)
" }}}

" -- Searching stuff {{
nnoremap <C-f> :Files<Cr>
nnoremap <C-g> :Rg<Cr>
vnoremap <C-g> y:Rg <C-R>"<CR>
noremap  <C-t> :Tags<CR>
nmap     <C-s> :Vista finder fzf:nvim_lsp<CR>


augroup ft_search_kb
    au!
    autocmd FileType tex nmap <silent><buffer>  <C-s> :call vimtex#fzf#run('ctli', g:fzf_layout)<cr>
augroup end

" Search for Zotero references
nnoremap  <silent><C-z> :call ZoteroCite()<CR>
inoremap  <silent><C-z> <C-o>:call ZoteroCite()<CR>

" }}}

" -- nvim-lsp {{{
augroup nvim_lsp_kb
    autocmd BufRead,BufEnter *  :call <SID>nvim_lsp_keybindings()
augroup end

function s:nvim_lsp_keybindings()
    nnoremap <silent> gc          <cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <silent> gd          <cmd>lua vim.lsp.buf.definition()<CR>
    nnoremap <silent> K           <cmd>lua vim.lsp.buf.hover()<CR>
    nnoremap <silent> gi          <cmd>lua vim.lsp.buf.implementation()<CR>
    nnoremap <silent> gr          <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <silent> pd          <cmd>lua vim.lsp.buf.peek_definition()<CR>
    nnoremap <silent> g0          <cmd>lua vim.lsp.buf.document_symbol()<CR>
    nnoremap <silent> <leader>ld  <cmd>lua require'diagnostic.util'.show_line_diagnostics()<CR>
endfunction

nnoremap <silent> <leader>d   :NextDiagnostic<CR>
nnoremap <silent> <leader>pd  :PrevDiagnostic<CR>
nnoremap <silent> <leader>od  :OpenDiagnostic<CR>
" }}}

" -- Pop-Up Menu {{{
"  Tab to scroll (SHIFT+Tab for backward scroll)
"  ESC to cancel
"  ENTER for accept
inoremap <silent><expr> <Esc>     pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <silent><expr> <CR>      pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <TAB>
            \ pumvisible() ? "\<C-y>" :
            \ <SID>check_back_space() ? "\<TAB>" :
            \ completion#trigger_completion()

function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
endfunction

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
" }}}

" -- Fern
" {{{
function! s:init_fern() abort
  nmap <buffer><expr>
      \ <Plug>(fern-my-expand-or-collapse)
      \ fern#smart#leaf(
      \   "\<Plug>(fern-action-collapse)",
      \   "\<Plug>(fern-action-expand)",
      \   "\<Plug>(fern-action-collapse)",
      \ )

  nmap <buffer><nowait> <CR> <Plug>(fern-my-expand-or-collapse)

  nmap <buffer> t <Plug>(fern-action-open:tabedit)
  nmap <buffer> T <Plug>(fern-action-open:tabedit)gT
  nmap <buffer> i <Plug>(fern-action-open:split)
  nmap <buffer> gi <Plug>(fern-action-open:split)<C-w>p
  nmap <buffer> s <Plug>(fern-action-open:vsplit)
  nmap <buffer> gs <Plug>(fern-action-open:vsplit)<C-w>p
  nmap <buffer> I <Plug>(fern-action-hide-toggle)

  nmap <buffer> d <Plug>(fern-action-remove)

  nmap <buffer> q :<C-u>quit<CR>
endfunction


augroup fern-custom-kb
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

nmap <silent><C-n> :Fern . -drawer -reveal=% -toggle -width=40<CR>

" }}}
