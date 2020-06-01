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


" -- NERDTree
" {{{
map <C-n> :NERDTreeToggle<CR>
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
nnoremap <C-t> :Tags<CR>
nnoremap <C-p> :Buffers<CR>
nmap     <C-s> :Vista finder fzf:nvim_lsp<CR>


" Search for Zotero references
nnoremap  <silent><C-z> :call ZoteroCite()<CR>
inoremap  <silent><C-z> <C-o>:call ZoteroCite()<CR>

" }}}

" -- nvim-lsp and ALE {{{
augroup lsp_kb
    au!
    autocmd BufRead,BufEnter *  :call <SID>lsp_keybindings()
augroup end

function s:lsp_keybindings()
    nnoremap <silent> gc          <cmd>lua vim.lsp.buf.declaration()<CR>
    nnoremap <silent> gd          <cmd>lua vim.lsp.buf.definition()<CR>
    " nnoremap <silent> gr          <cmd>lua vim.lsp.buf.references()<CR>
    nnoremap <silent> pd          <cmd>lua vim.lsp.buf.peek_definition()<CR>
    nnoremap <silent> g0          <cmd>lua vim.lsp.buf.document_symbol()<CR>
    nnoremap <silent> <leader>ld  <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>

    nmap <silent>   gi          <Plug>(nvim-lsp-implementation)
    nmap <silent>   K           <Plug>(nvim-lsp-hover)
    nmap <silent>   <leader>f   <Plug>(nvim-lsp-formatting)

    nmap <silent>   <leader>r   <cmd>call completion_treesitter#smart_rename()<CR>
endfunction

nnoremap <silent> <leader>d   <cmd>NextDiagnostic<CR>
nnoremap <silent> <leader>pd  <cmd>PrevDiagnostic<CR>
nnoremap <silent> <leader>od  <cmd>OpenDiagnostic<CR>
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
