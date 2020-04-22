" -- Fishshell fixes
if &shell =~# 'fish$'
  set shell=sh
endif

" -- Sanity settings {{{
set secure
set modelines=0 " Disable Modelines
set number      " Show line numbers
set ruler       " Show file stats
set visualbell  " Blink cursor on error instead of beeping (grr)
set encoding=utf-8  " Encoding

set wrap
set linebreak
set textwidth=0

set formatoptions=cqrn

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set noshiftround

set conceallevel=2
set foldnestmax=10
set nofoldenable
set foldlevel=2
set foldmethod=syntax

set hidden  " Allow hidden buffers
set laststatus=2  " Status bar

set list                   " Show non-printable characters.
set listchars=tab:▸\ ,extends:❯,precedes:❮,nbsp:±,trail:·

" Searching
set ignorecase
set smartcase
set showmatch

" Spelling
set spelllang=en_us
set nospell

" Interface Settings
set background=dark
set mouse=a
set noshowmode

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert

" Avoid showing message extra message when using completion
set shortmess+=c

" Split pane settings

" Right and bottom splits as opposed to left and top
set splitbelow
set splitright
" }}}

runtime conf.d/plugins.vim

augroup ft_mappings
  au!
  autocmd BufRead,BufNewFile *.tex,*.latex  set filetype=tex
augroup end

runtime conf.d/lintcomp.vim
runtime conf.d/ui.vim
runtime conf.d/keybindings.vim

runtime conf.d/writing.vim
