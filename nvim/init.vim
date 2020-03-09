" -- Shell Problems
if &shell =~# 'fish$'
  set shell=sh
endif

" -- Sane defaults 

set modelines=0 " Disable Modelines
set number      " Show line numbers
set ruler       " Show file stats
set visualbell  " Blink cursor on error instead of beeping (grr)
set encoding=utf-8  " Encoding

set wrap
set textwidth=0
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

set hidden  " Allow hidden buffers
set laststatus=2  " Status bar

" -- Searching
set ignorecase
set smartcase
set showmatch

" -- Spelling
set spelllang=en_us
nnoremap <silent> <leader>ts :set spell!<CR>

" -- Interface Settings
set background=dark
set mouse=a

" -- Pop-Up Menu
"  Tab to scroll (SHIFT+Tab for backward scroll)
"  ESC to cancel
"  ENTER for accept
inoremap <silent><expr> <Esc>     pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <silent><expr> <CR>      pumvisible() ? "\<C-y>\<cr>" : "\<CR>"
inoremap <silent><expr> <tab>     pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <silent><expr> <s-tab>   pumvisible() ? "\<C-p>" : "\<s-tab>"

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif


" -- PLUGINS
let pluginpath = stdpath('data') . '/plugged'
call plug#begin(pluginpath)

" Sanity stuff
Plug 'ciaranm/securemodelines'

" Backend Tools
Plug 'SirVer/ultisnips'
" {{
let g:UltiSnipsExpandTrigger = '<nop>'
let g:UltiSnipsJumpForwardTrigger = '<c-j>'
let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
let g:UltiSnipsRemoveSelectModeMappings = 0
" }}
Plug 'honza/vim-snippets'

Plug 'dense-analysis/ale'
" {{
let g:ale_set_signs = 0

let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_delay = 0

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] [%severity%] %s'

let g:ale_statusline_format = ['Errors: %d', 'Warnings: %d', '']

let g:ale_linters = {
      \ 'tex': [],
      \ 'python': ['pylint'],
      \}

nmap <silent> <leader>aa <Plug>(ale_lint)
nmap <silent> <leader>aj <Plug>(ale_next_wrap)
nmap <silent> <leader>ak <Plug>(ale_previous_wrap)
" }}

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-sources'
" {{
let g:coc_global_extensions = [
      \ 'coc-actions',
      \ 'coc-word',
      \ 'coc-snippets',
      \ 'coc-yaml',
      \ 'coc-json',
      \ 'coc-rls',
      \ 'coc-python'
      \]

inoremap <silent><expr> <TAB>
      \ pumvisible() ? coc#_select_confirm() :
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

imap <silent> <c-u>      <plug>(coc-snippets-expand)

nmap <silent> <leader>ld <plug>(coc-definition)zv
nmap <silent> <leader>lt <plug>(coc-type-definition)
nmap <silent> <leader>li <plug>(coc-implementation)
nmap <silent> <leader>lf <plug>(coc-references)
nmap          <leader>lr <plug>(coc-rename)

nmap <silent> <leader>lp <plug>(coc-diagnostic-prev)
nmap <silent> <leader>ln <plug>(coc-diagnostic-next)

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

if exists('*CocActionAsync')
  augroup coc_settings
    autocmd!
    autocmd CursorHold * silent call CocActionAsync('highlight')
  augroup END
endif
" }}

Plug 'rhysd/vim-grammarous'
" {{
let g:grammarous#default_comments_only_filetypes = {
      \ '*' : 1, 'help' : 0, 'markdown' : 0, 'tex': 0, 'latex' : 0
      \ }
" }}

" Good tools
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" {{
nnoremap <C-f> :Files<Cr>
nnoremap <C-g> :Rg<Cr>

let g:fzf_layout = { 'down': '~40%' }
" }}
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-easy-align'
" {{
let g:easy_align_bypass_fold = 1

nmap ga <plug>(LiveEasyAlign)
vmap ga <plug>(LiveEasyAlign)
nmap gA <plug>(EasyAlign)
vmap gA <plug>(EasyAlign)
vmap .  <plug>(EasyAlignRepeat)
" }}
Plug 'andymass/vim-matchup'

" ctags
Plug 'ludovicchabant/vim-gutentags'
" {{
let g:gutentags_cache_dir = expand('~/.cache/vim/ctags/')
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+aimS',
      \ ]
let g:gutentags_file_list_command = {
      \ 'markers': {
      \   '.git': 'git ls-files',
      \   '.hg': 'hg files',
      \ },
      \}
" }}
Plug 'majutsushi/tagbar'
" {{
nmap <F8> :TagbarToggle<CR>
nnoremap <silent> <leader>tb :TagbarToggle<CR>
" }}

" Language specific
Plug 'lervag/vimtex'
" {{
let g:tex_stylish = 1
let g:tex_conceal = ''
let g:tex_flavor = 'latex'
let g:tex_isk='48-57,a-z,A-Z,192-255,:'

let g:vimtex_fold_enabled = 1
let g:vimtex_fold_types = {
      \ 'markers' : {'enabled': 0},
      \ 'sections' : {'parse_levels': 1},
      \}
let g:vimtex_format_enabled = 1
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_automatic = 0
let g:vimtex_view_forward_search_on_start = 0
let g:vimtex_toc_config = {
      \ 'split_pos' : 'full',
      \ 'mode' : 2,
      \ 'fold_enable' : 1,
      \ 'hotkeys_enabled' : 1,
      \ 'hotkeys_leader' : '',
      \ 'refresh_always' : 0,
      \}
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_quickfix_autoclose_after_keystrokes = 3
let g:vimtex_imaps_enabled = 0
let g:vimtex_complete_img_use_tail = 1
let g:vimtex_complete_bib = {
      \ 'simple' : 1,
      \ 'menu_fmt' : '@year, @author_short, @title',
      \}
let g:vimtex_echo_verbose_input = 0
let g:vimtex_compiler_progname='nvr'
" }}

Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'

Plug 'plasticboy/vim-markdown'
" {{
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_math = 1
" }}
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install' }

Plug 'rhysd/vim-clang-format'
" {{
" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" if you install vim-operator-user
autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)

" }}

Plug 'rust-lang/rust.vim'
" {{
let g:autofmt_autosave = 1
" }}
Plug 'ziglang/zig.vim'

Plug 'cespare/vim-toml'
Plug 'robertbasic/vim-hugo-helper'

" Shell Support
Plug 'dag/vim-fish'
Plug 'pprovost/vim-ps1'

" Visual
Plug 'patstockwell/vim-monokai-tasty'
" {{
let g:vim_monokai_tasty_italic = 1
let g:airline_theme='monokai_tasty'
" }}

Plug 'scrooloose/nerdtree'
Plug 'albfan/nerdtree-git-plugin'
" {{
" let loaded_netrwPlugin=1
let g:NERDTreeRespectWildIgnore=1

augroup nerdtree
  autocmd!
  autocmd StdinReadPre * let s:std_in=1
  " autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
augroup END

map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1

let g:NERDTreeIndicatorMapCustom = {
      \ "Modified"  : "✹",
      \ "Staged"    : "✚",
      \ "Untracked" : "✭",
      \ "Renamed"   : "➜",
      \ "Unmerged"  : "═",
      \ "Deleted"   : "✖",
      \ "Dirty"     : "✗",
      \ "Clean"     : "✔︎",
      \ 'Ignored'   : '☒',
      \ "Unknown"   : "?"
      \ }
" }}
Plug 'ddollar/nerdcommenter'

Plug 'vim-airline/vim-airline'
" {{
let g:airline_left_sep  = ''
let g:airline_right_sep = ''
let g:airline#extensions#ale#enabled = 1
let airline#extensions#ale#error_symbol = 'E:'
let airline#extensions#ale#warning_symbol = 'W:'
let g:airline_powerline_fonts = 1
" }}

Plug 'airblade/vim-gitgutter'
Plug 'ryanoasis/vim-devicons'

call plug#end()
filetype plugin on

augroup VCenterCursor
  au!
  au BufEnter,WinEnter,WinNew,VimResized *,*.*
        \ let &scrolloff=winheight(win_getid())/2
augroup END

