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
" nnoremap <C-f> :Files<Cr>
" nnoremap <C-g> :Rg<Cr>

" nnoremap <C-s> :RG<CR>
" }}

" -- Denite {{
"   ;         - Browser currently open buffers
"   <C-f> - Browse list of files in current directory
"   <C-g> - Search current directory for occurences of given term and close window if no results
"   <C-s> - Search current directory for occurences of word under cursor
nmap ;              :Denite buffer<CR>
nnoremap <C-f>      :DeniteProjectDir file/rec<CR>
nnoremap <C-g>      :<C-u>Denite grep:.<CR>
nnoremap <C-j>      :<C-u>DeniteCursorWord grep:.<CR>

" Define mappings while in 'filter' mode
"   <C-o>         - Switch to normal mode inside of search results
"   <Esc>         - Exit denite window in any mode
"   <CR>          - Open currently selected file in any mode
"   <C-t>         - Open currently selected file in a new tab
"   <C-v>         - Open currently selected file a vertical split
"   <C-x>         - Open currently selected file in a horizontal split
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o>               <Plug>(denite_filter_quit)
  inoremap <silent><buffer><expr> <Esc>     denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>     denite#do_map('quit')
  inoremap <silent><buffer><expr> <CR>      denite#do_map('do_action')
  inoremap <silent><buffer><expr> <C-t>     denite#do_map('do_action', 'tabopen')
  inoremap <silent><buffer><expr> <C-v>     denite#do_map('do_action', 'vsplit')
  inoremap <silent><buffer><expr> <C-x>     denite#do_map('do_action', 'split')
endfunction

" Define mappings while in denite window
"   <CR>        - Opens currently selected file
"   q or <Esc>  - Quit Denite window
"   d           - Delete currenly selected file
"   p           - Preview currently selected file
"   <C-o> or i  - Switch to insert mode inside of filter prompt
"   <C-t>       - Open currently selected file in a new tab
"   <C-v>       - Open currently selected file a vertical split
"   <C-x>       - Open currently selected file in a horizontal split
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>      denite#do_map('do_action')
  nnoremap <silent><buffer><expr> q         denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>     denite#do_map('quit')
  nnoremap <silent><buffer><expr> d         denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p         denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> i         denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-o>     denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-t>     denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr> <C-v>     denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> <C-x>     denite#do_map('do_action', 'split')
endfunction
" }}

" -- Linter/Completions {{{
nmap <silent> <leader>aa <Plug>(ale_lint)
nmap <silent> <leader>ln <Plug>(ale_next_wrap)
nmap <silent> <leader>lp <Plug>(ale_previous_wrap)


imap <silent> <c-u>      <plug>(coc-snippets-expand)

nmap <silent> <leader>ld <plug>(coc-definition)
nmap <silent> <leader>lt <plug>(coc-type-definition)
nmap <silent> <leader>li <plug>(coc-implementation)
nmap <silent> <leader>lf <plug>(coc-references)
nmap          <leader>lr <plug>(coc-rename)

" Don't need, use ALE for diagnostics
" nmap <silent> <leader>lp <plug>(coc-diagnostic-prev)
" nmap <silent> <leader>ln <plug>(coc-diagnostic-next)

" Formatting selected code.
vmap <leader>gf  <Plug>(coc-format-selected)
nmap <leader>gf  <Plug>(coc-format-selected)

" Use default formatter
command! -nargs=0 Format :call CocAction('format')

" Use K to show doocumentation
nnoremap <silent> K :call <sid>show_documentation()<cr>
function! s:show_documentation()
  if index(['vim','help'], &filetype) >= 0
    execute 'help ' . expand('<cword>')
  elseif &filetype ==# 'tex'
    VimtexDocPackage
  else
    call CocAction('doHover')
  endif
endfunction
" }}}

" -- Pop-Up Menu {{{
"  Tab to scroll (SHIFT+Tab for backward scroll)
"  ESC to cancel
"  ENTER for accept
inoremap <silent><expr> <Esc>     pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <silent><expr> <CR>      pumvisible() ? "\<C-y>\<cr>" : "\<CR>"
inoremap <silent><expr> <S-TAB>   pumvisible() ? "\<C-p>" : "\<S-TAB>"
inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
" }}}
