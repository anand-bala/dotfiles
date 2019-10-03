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

" -- Interface Settings
set background=dark
set mouse=a

" -- Windows stuff
" if has('win32')
"   let g:uython3_host_prog = 'C:\Users\anand\AppData\Local\Microsoft\WindowsApps\python3.exe'
" endif

" -- PLUGINS
let pluginpath = stdpath('data') . '/plugged'
call plug#begin(pluginpath)

" Sanity stuff
Plug 'ciaranm/securemodelines'

" Visual
if has('win32')
  Plug 'dracula/vim', { 'as': 'dracula' }
endif

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

Plug 'w0rp/ale'
" {{
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = 'never'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" }}

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-sources'
" {{
inoremap <silent><expr> <c-space> coc#refresh()
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" }}

" Good tools
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" {{
nnoremap <C-f> :Files<Cr>
nnoremap <C-g> :Rg<Cr>

let g:fzf_layout = { 'down': '~40%' }
" }}

" Language specific
Plug 'lervag/vimtex'
" Plug 'neoclide/coc-vimtex'
" {{
let g:tex_flavor = "latex"

if has('win32')
  let g:vimtex_view_general_viewer = 'SumatraPDF'
  let g:vimtex_view_general_options='-reuse-instance -forward-search @tex @line @pdf'
  let g:vimtex_view_general_options_latexmk='-reuse-instance'
else 
  let g:vimtex_view_method='zathura'
endif
" let g:vimtex_quickfix_mode=0
" }}
Plug 'plasticboy/vim-markdown'

Plug 'ziglang/zig.vim'

call plug#end()
filetype plugin on

if has('win32')
  colorscheme dracula
endif

