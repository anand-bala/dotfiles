
" -- PLUGINS
call plug#begin()

" Visual
Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'scrooloose/nerdtree'
Plug 'ddollar/nerdcommenter'
Plug 'xuyuanp/nerdtree-git-plugin'

Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'ryanoasis/vim-devicons'

" Backend Tools
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'w0rp/ale'

" Deoplete + Language specific
Plug 'deoplete-plugins/deoplete-jedi'
Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}


" Language specific
Plug 'lervag/vimtex'
Plug 'plasticboy/vim-markdown'


call plug#end()
filetype plugin on

" -- VISUAL
set background=dark

set mouse=a

" --- Sane defaults 

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

" --- Searching
set ignorecase
set smartcase
set showmatch
" -- Airline
let g:airline_left_sep  = ''
let g:airline_right_sep = ''
let g:airline#extensions#ale#enabled = 1
let airline#extensions#ale#error_symbol = 'E:'
let airline#extensions#ale#warning_symbol = 'W:'

" --- NERDTree
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


" -- Spelling
set spelllang=en_us

" -- UltiSnips
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

" -- Deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_smart_case = 1

" disable autocomplete by default
let b:deoplete_disable_auto_complete=1
let g:deoplete_disable_auto_complete=1

au BufRead,BufNewFile *.md setlocal textwidth=80
au BufRead,BufNewFile *.tex setlocal textwidth=80

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" -- ALE

let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" -- TeX
let g:tex_flavor = "latex"
let g:vimtex_view_method='zathura'
" let g:vimtex_quickfix_mode=0

