
" -- PLUGINS
call plug#begin('~/.local/share/nvim/plugged')

" Sanity stuff
Plug 'ciaranm/securemodelines'

" Visual
Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'scrooloose/nerdtree'
" {{
  let loaded_netrwPlugin=1
  let NERDTreeRespectWildIgnore=1

  augroup nerdtree
    autocmd!
    autocmd StdinReadPre * let s:std_in=1
    " autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
  augroup END

  map <C-n> :NERDTreeToggle<CR>
  let g:NERDTreeAutoDeleteBuffer = 1
  " let g:NERDTreeMinimalUI = 1
  let g:NERDTreeDirArrows = 1
" }}
Plug 'ddollar/nerdcommenter'
Plug 'xuyuanp/nerdtree-git-plugin'

Plug 'vim-airline/vim-airline'
" {{
  let g:airline_left_sep  = ''
  let g:airline_right_sep = ''
  let g:airline#extensions#ale#enabled = 1
  let airline#extensions#ale#error_symbol = 'E:'
  let airline#extensions#ale#warning_symbol = 'W:'
" }}

Plug 'airblade/vim-gitgutter'
Plug 'ryanoasis/vim-devicons'

" Backend Tools
Plug 'SirVer/ultisnips'
" {{
  let g:UltiSnipsExpandTrigger = '<tab>'
  let g:UltiSnipsJumpForwardTrigger = '<tab>'
  let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
" }}
Plug 'honza/vim-snippets'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" {{
  let g:deoplete#enable_at_startup = 1
  let g:deoplete#enable_smart_case = 1

  " disable autocomplete by default
  let b:deoplete_disable_auto_complete=1
  let g:deoplete_disable_auto_complete=1
" }}
Plug 'w0rp/ale'
" {{
  let g:ale_lint_on_enter = 0
  let g:ale_lint_on_text_changed = 'never'
  let g:ale_echo_msg_error_str = 'E'
  let g:ale_echo_msg_warning_str = 'W'
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" }}

" Good tools
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" {{
  nnoremap <C-f> :Files<Cr>
  nnoremap <C-g> :Rg<Cr>

  let g:fzf_layout = { 'up': '~40%' }
" }}

Plug 'sakhnik/nvim-gdb', { 'do': ':UpdateRemotePlugins' }

" Deoplete + Language specific
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}


" Language specific
Plug 'lervag/vimtex'
" {{
  let g:tex_flavor = "latex"
  let g:vimtex_view_method='zathura'
  " let g:vimtex_quickfix_mode=0
" }}
Plug 'plasticboy/vim-markdown'

Plug 'ziglang/zig.vim'

call plug#end()
filetype plugin on

set background=dark
set mouse=a

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

" -- Pop-Up Menu
"  Tab to scroll (SHIFT+Tab for backward scroll)
"  ESC to cancel
"  ENTER for accept
inoremap <silent><expr> <Esc>     pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <silent><expr> <CR>      pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <silent><expr> <tab>     pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <silent><expr> <s-tab>   pumvisible() ? "\<C-p>" : "\<s-tab>"

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" -- Spelling
set spelllang=en_us
nnoremap <silent> <leader>ts :set spell!<CR>

" -- Misc
au BufRead,BufNewFile *.md setlocal textwidth=80
au BufRead,BufNewFile *.tex setlocal textwidth=80



