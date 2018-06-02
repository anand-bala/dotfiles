" Don't try to be vi compatible
set nocompatible


" Detect Environment {
silent function! OSX()
return has('macunix')
endfunction

silent function! LINUX()
return has('unix') && !has('macunix') && !has('win32unix')
endfunction

silent function! WINDOWS()
return  (has('win32') || has('win64'))
endfunction
" }

" Helps force plugins to load correctly when it is turned back on below
filetype off

" TODO: Load plugins here (pathogen or vundle)
call plug#begin()
" Config shit
Plug 'tpope/vim-sensible'
Plug 'editorconfig/editorconfig-vim'

" Appearance
Plug 'NLKNguyen/papercolor-theme'

Plug 'scrooloose/nerdtree'
Plug 'ddollar/nerdcommenter'
Plug 'xuyuanp/nerdtree-git-plugin'
Plug 'octref/RootIgnore'

Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'ryanoasis/vim-devicons'


" Utilities
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-fugitive'

Plug 'w0rp/ale'

Plug 'Shougo/deoplete.nvim'
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'
Plug 'Shougo/neosnippet'
Plug 'Shougo/neosnippet-snippets'

Plug 'shougo/denite.nvim'
Plug 'shougo/deol.nvim'

" Language specific shit
"" Golang
Plug 'zchee/deoplete-go',
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

"" Rust
Plug 'sebastianmarkow/deoplete-rust'
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
colorscheme PaperColor
filetype plugin on


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

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

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

" Formatting
map <leader>q gqip

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" Uncomment this to enable by default:
set list " To enable by default
" Or use your leader key + l to toggle on/off
" map <leader>l :set list!<CR> " Toggle tabs and EOL

" Autosave on changing buffer or losing focus
autocmd BufLeave,FocusLost * silent! wall

" NERDTree
let loaded_netrwPlugin=1
let NERDTreeRespectWildIgnore=1

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

map <C-n> :NERDTreeToggle<CR>

" let g:NERDTreeDirArrowExpandable = '▸'
" let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1

" Vim Devicons
if !LINUX()
  set guifont=Go\-Mono 11
else
  set guifont=DroidSansMono_Nerd_Font:h11
endif

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

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
autocmd QuitPre * if empty(&bt) | lclose | endif

nmap <leader>d <Plug>(ale_fix)

"" ALE stuff
let g:ale_fixers = {
      \   'javascript': ['eslint'],
      \   'rust': ['rustfmt'],
      \}

let g:ale_linters = {
      \   'markdown': ['vale'],
      \}

" Airline
let g:airline#extensions#ale#enabled = 1

" Deoplete
let g:deoplete#enable_at_startup = 1
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
" let g:deoplete#disable_auto_complete = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
let g:deoplete#sources#go#gocode_binary = '/home/anand/go/bin/gocode'

" Rust
autocmd FileType rust let b:dispatch = 'cargo run'
let g:cargo_command = "Dispatch cargo {cmd}"
let g:ale_rust_rls_toolchain = 'stable'
let g:deoplete#sources#rust#racer_binary='/home/anand/.cargo/bin/racer'
let g:deoplete#sources#rust#rust_source_path='/home/anand/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src'


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

" Use tern_for_vim.
let g:tern#command = ["tern"]
let g:tern#arguments = ["--persistent"]


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
