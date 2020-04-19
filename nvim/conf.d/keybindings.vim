" File: keybindings.vim
" Author: Anand Balakrishnan
" Description: Custom keybindings for various plugins


" -- EasyAlign {{{
nmap ea <plug>(LiveEasyAlign)
vmap ea <plug>(LiveEasyAlign)
nmap eA <plug>(EasyAlign)
vmap eA <plug>(EasyAlign)
vmap .  <plug>(EasyAlignRepeat)
" }}}

" -- FZF {{
nnoremap <C-f> :Files<Cr>
nnoremap <C-g> :Rg<Cr>
vnoremap <C-g> y/<C-R>"<CR> 
" }}

" -- Vista {{{
nnoremap <silent> <C-s>     :Vista finder fzf:coc<CR>
" }}}

" -- Linter/Completions {{{
" nmap <silent> <leader>aa <Plug>(ale_lint)
" nmap <silent> <leader>ln <Plug>(ale_next_wrap)
" nmap <silent> <leader>lp <Plug>(ale_previous_wrap)

" imap <silent> <c-u>      <plug>(coc-snippets-expand)

" nmap <silent> <leader>gd <plug>(coc-definition)
" nmap <silent> <leader>gt <plug>(coc-type-definition)
" nmap <silent> <leader>gi <plug>(coc-implementation)
" nmap <silent> <leader>lf <plug>(coc-references)
" nmap          <leader>lr <plug>(coc-rename)

" " Don't need, use ALE for diagnostics
" " nmap <silent> <leader>lp <plug>(coc-diagnostic-prev)
" " nmap <silent> <leader>ln <plug>(coc-diagnostic-next)

" " Formatting selected code.
" vmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

" " Use default formatter
" command! -nargs=0 Format :call CocAction('format')

" " Use K to show doocumentation
" nnoremap <silent> K :call <sid>show_documentation()<cr>
" function! s:show_documentation()
  " if index(['vim','help'], &filetype) >= 0
    " execute 'help ' . expand('<cword>')
  " elseif &filetype ==# 'tex'
    " VimtexDocPackage
  " else
    " call CocAction('doHover')
  " endif
" endfunction
" }}}

" -- nvim-lsp {{{
nnoremap <silent> gc          <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gd          <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K           <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi          <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> gr          <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> pd          <cmd>lua vim.lsp.buf.peek_definition()<CR>
nnoremap <silent> g0          <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> ]d          :NextDiagnostic<CR>
nnoremap <silent> [d          :PrevDiagnostic<CR>
nnoremap <silent> <leader>do  :OpenDiagnostic<CR>
nnoremap <silent> <leader>dl  <cmd>lua vim.lsp.util.show_line_diagnostics()<CR>
" }}}

" -- Pop-Up Menu {{{
"  Tab to scroll (SHIFT+Tab for backward scroll)
"  ESC to cancel
"  ENTER for accept
inoremap <silent><expr> <Esc>     pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <silent><expr> <CR>      pumvisible() ? "\<C-y>\<cr>" : "\<CR>"
inoremap <silent><expr> <S-TAB>   pumvisible() ? "\<C-p>" : "\<C-h>"
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ completion#trigger_completion()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
" }}}
