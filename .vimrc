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
Plug 'embear/vim-localvimrc'

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
Plug 'shougo/neoinclude.vim'
"" Golang
Plug 'zchee/deoplete-go',
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
"" Rust
Plug 'racer-rust/vim-racer', { 'for': 'rust' }
Plug 'timonv/vim-cargo'

"" Python
Plug 'zchee/deoplete-jedi'
Plug 'davidhalter/jedi-vim'
"" HTML
Plug 'mattn/emmet-vim'
"" TOML
Plug 'cespare/vim-toml'
"" TeX
Plug 'lervag/vimtex'
"" Markdown
Plug 'plasticboy/vim-markdown'

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

" Autosave on changing buffer or losing focus
autocmd BufLeave,FocusLost * silent! wall

" if (has("termguicolors"))
"   set termguicolors
" endif
" let g:palenight_terminal_italics=1


"------------------------------------------------------------ Visual Settings

" NERDTree
let loaded_netrwPlugin=1
let NERDTreeRespectWildIgnore=1
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1

" Vim Devicons
set guifont=DroidSansMono_Nerd_Font:h11

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

augroup CloseLoclistWindowGroup
  autocmd!
  autocmd QuitPre * if empty(&buftype) | lclose | endif
augroup END

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
autocmd QuitPre * if empty(&bt) | lclose | endif

nmap <leader>d <Plug>(ale_fix)

"" ALE stuff
let g:ale_fixers = {
      \   'javascript': ['eslint'],
      \   'rust': ['rustfmt'],
      \   'c': ['clang-format'],
      \}

let g:ale_linters = {
      \   'markdown': ['redpen'],
      \   'tex': ['redpen']
      \}

" Deoplete
let g:deoplete#enable_at_startup = 1
" if !exists('g:deoplete#omni#input_patterns')
"   let g:deoplete#omni#input_patterns = {}
" endif
" " let g:deoplete#disable_auto_complete = 1
" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
" inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#gocode_binary = '/home/anand/go/bin/gocode'

" Rust
autocmd FileType rust let b:dispatch = 'cargo run %'
let g:cargo_command = "Dispatch cargo {cmd}"

let g:ale_rust_rls_toolchain = 'stable'

let g:racer_cmd = '/home/anand/.cargo/bin/racer'
let g:racer_experimental_completer = 1

au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)


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

" C/C++
let g:deoplete#sources#clang#libclang_path = '/usr/lib/llvm-3.9/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/usr/lib/clang'

" Markdown
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1

let vim_markdown_preview_hotkey='<C-m>'

" Golang
let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
let g:deoplete#sources#go#package_dot = 1
let g:deoplete#sources#go#pointer = 1
