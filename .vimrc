set nocompatible
filetype off

"---------------------------------------------------------------------- PLUGINS

call plug#begin()
Plug 'altercation/vim-colors-solarized'
Plug 'drewtempelmeyer/palenight.vim'

Plug 'tpope/vim-sensible'

Plug 'scrooloose/nerdtree'
Plug 'ddollar/nerdcommenter'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'octref/RootIgnore'

Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'ryanoasis/vim-devicons'

Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'w0rp/ale'

Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'

""ARM ASM
Plug 'alisdair/vim-armasm'
"" C/C++
Plug 'zchee/deoplete-clang'
Plug 'zchee/libclang-python3'
Plug 'shougo/neoinclude.vim'
"" Golang
Plug 'zchee/deoplete-go',
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
"" Python
Plug 'zchee/deoplete-jedi'
"" Rust
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer', { 'for': 'rust' }
"" Kotlin
Plug 'udalov/kotlin-vim'
"" TOML
Plug 'cespare/vim-toml'
"" TeX
Plug 'lervag/vimtex'
"" Markdown
Plug 'plasticboy/vim-markdown'
Plug 'suan/vim-instant-markdown'

call plug#end()

set background=dark
colorscheme palenight
filetype plugin on

"-------------------------------------------------------- DEFAULT CONFIGURATION

set modelines=0 " Disable Modelines
set number      " Show line numbers
set ruler       " Show file stats
set visualbell  " Blink cursor on error instead of beeping (grr)
set encoding=utf-8  " Encoding

" Whitespace
set wrap
set textwidth=0
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

set hidden  " Allow hidden buffers
set ttyfast " Rendering
set laststatus=2  " Status bar

" Last line
set showmode
set showcmd

" Searching
set ignorecase
set smartcase
set showmatch

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" Uncomment this to enable by default:
set list " To enable by default


" if (has("termguicolors"))
"   set termguicolors
" endif
" let g:palenight_terminal_italics=1

set pyxversion=3
set pyx=3


"------------------------------------------------------------ Visual Settings

" NERDTree
let loaded_netrwPlugin=1
let NERDTreeRespectWildIgnore=1

augroup nerdtree
  autocmd!
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
augroup END

map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1

" Vim Devicons
set guifont=DroidSansMono\ Nerd\ Font:h11

" Airline
let g:airline#extensions#ale#enabled = 1


"------------------------------------------------------ Helper Plugins Settings
"                                                                Dispatch, ALE,

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Dispatch config
nnoremap <F9> :Dispatch<CR>

" ALE config
let g:ale_sign_column_always = 1
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_set_highlights = 0
let g:ale_fix_on_save = 1

let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_list_window_size = 5
let g:ale_keep_list_window_open = 1


let g:airline#extensions#ale#enabled = 1


" Deoplete
let g:deoplete#enable_at_startup = 1
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"


" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
"imap <expr><TAB>
" \ pumvisible() ? "\<C-n>" :
" \ neosnippet#expandable_or_jumpable() ?
" \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1
" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/plugged/vim-snippets/snippets'



