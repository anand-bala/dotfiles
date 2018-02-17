" Don't try to be vi compatible
set nocompatible

" Helps force plugins to load correctly when it is turned back on below
filetype off

" TODO: Load plugins here (pathogen or vundle)
execute pathogen#infect()

" Turn on syntax highlighting
syntax on

" For plugins to load correctly
filetype plugin indent on
filetype plugin on

" TODO: Pick a leader key
" let mapleader = ","

" Security
set modelines=0

" Show line numbers
set number

" Show file stats
set ruler

" Blink cursor on error instead of beeping (grr)
set visualbell

" Encoding
set encoding=utf-8

" Whitespace
set wrap
set textwidth=0
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" Cursor motion
set scrolloff=3
set backspace=indent,eol,start
set matchpairs+=<:> " use % to jump between pairs
runtime! macros/matchit.vim

" Move up/down editor lines
nnoremap j gj
nnoremap k gk

" Allow hidden buffers
set hidden

" Rendering
set ttyfast

" Status bar
set laststatus=2

" Last line
set showmode
set showcmd

" Searching
nnoremap / /\v
vnoremap / /\v
set hlsearch
set incsearch
set ignorecase
set smartcase
set showmatch
map <leader><space> :let @/=''<cr> " clear search

" Remap help key.
inoremap <F1> <ESC>:set invfullscreen<CR>a
nnoremap <F1> :set invfullscreen<CR>
vnoremap <F1> :set invfullscreen<CR>

" Textmate holdouts

" Formatting
map <leader>q gqip

" Visualize tabs and newlines
set listchars=tab:▸\ ,eol:¬
" Uncomment this to enable by default:
set list " To enable by default
" Or use your leader key + l to toggle on/off
" map <leader>l :set list!<CR> " Toggle tabs and EOL

" Handle *.md files properly
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd FileType markdown setlocal spell
autocmd FileType markdown setlocal textwidth=80
set complete+=kspell

let g:markdownfmt_command = 'mdfmt'
au FileType markdown nmap <leader>s :<C-u>call markdownfmt#Format()<CR>

" NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

map <C-n> :NERDTreeToggle<CR>
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" Vim Devicons
set guifont=DroidSansMono_Nerd_Font:h11

" Vim-Latex Suite
let g:tex_flavor='latex'

"" Use \lx to compile using xelatex
function CompileXeTex()
    let oldCompileRule=g:Tex_CompileRule_pdf
    let g:Tex_CompileRule_pdf = 'xelatex -aux-directory=F:/Vim/my_latex_doc/temp --synctex=-1 -src-specials -interaction=nonstopmode $*'
    call Tex_RunLaTeX()
    let g:Tex_CompileRule_pdf=oldCompileRule
endfunction

map <Leader>lx :<C-U>call CompileXeTex()<CR>

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Rust Config
let g:racer_cmd = "/Users/anandbalakrishnan/.cargo/bin/racer"
let g:racer_experimental_completer = 1

" Golang Config
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1

let g:go_metalinter_enabled = ['golint', 'errcheck']
let g:go_metalinter_autosave = 1
let g:go_metalinter_deadline = "5s"

let g:go_def_mode = 'godef'
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1

