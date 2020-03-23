" File: sane.vim
" Author: Anand Balakrishnan
" Description: Sane defaults for my Vim configuration

set modelines=0 " Disable Modelines
set number      " Show line numbers
set ruler       " Show file stats
set visualbell  " Blink cursor on error instead of beeping (grr)
set encoding=utf-8  " Encoding

set wrap
set linebreak
set textwidth=0
set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround

" set conceallevel=2

set hidden  " Allow hidden buffers
set laststatus=2  " Status bar

set list                   " Show non-printable characters.
set listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:±,trail:·

" -- Searching
set ignorecase
set smartcase
set showmatch

" -- Spelling
set spelllang=en_us
set nospell
nnoremap <silent> <leader>ts :set spell!<CR>

" -- Interface Settings
set background=dark
set mouse=a

" -- Split pane settings

" Right and bottom splits as opposed to left and top
set splitbelow
set splitright

" -- Pop-Up Menu
"  Tab to scroll (SHIFT+Tab for backward scroll)
"  ESC to cancel
"  ENTER for accept
inoremap <silent><expr> <Esc>     pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <silent><expr> <CR>      pumvisible() ? "\<C-y>\<cr>" : "\<CR>"
inoremap <silent><expr> <tab>     pumvisible() ? "\<C-n>" : "\<tab>"
inoremap <silent><expr> <s-tab>   pumvisible() ? "\<C-p>" : "\<s-tab>"

autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif
