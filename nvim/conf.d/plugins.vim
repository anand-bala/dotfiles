" File: plugins.vim
" Author: Anand Balakrishnan
" Description: Collection of plugins for my Vim config


" Platform portable way of setting the plugin download path
let pluginpath = stdpath('data') . '/plugged'
call plug#begin(pluginpath)

" -- Sanity stuff
Plug 'ciaranm/securemodelines'

" -- Everyday tools
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'

Plug 'tpope/vim-abolish'
Plug 'arthurxavierx/vim-caser'

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-easy-align'
" {{
let g:easy_align_bypass_fold = 1
" }}

Plug 'andymass/vim-matchup'

Plug 'preservim/nerdcommenter'
" {{
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" }}

" Fuzzy search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin --no-fish' }
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'

" -- Completions, Linting, and Snippets

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'dense-analysis/ale'
Plug 'neovim/nvim-lsp'
Plug 'haorenW1025/completion-nvim'
Plug 'vigoux/completion-treesitter'
Plug 'haorenW1025/diagnostic-nvim'
" }}}

" ctags
Plug 'ludovicchabant/vim-gutentags'
Plug 'liuchengxu/vista.vim'

" -- Language specific
Plug 'lervag/vimtex'

Plug 'plasticboy/vim-markdown'
Plug 'mzlogin/vim-markdown-toc'

Plug 'ziglang/zig.vim'
Plug 'rust-lang/rust.vim'
" {{
let g:autofmt_autosave = 1
" }}

Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'tpope/vim-liquid'

" Shell Support
Plug 'dag/vim-fish'
Plug 'pprovost/vim-ps1'

" -- Writing!
Plug 'junegunn/goyo.vim'
" - stuff

Plug 'preservim/nerdtree'
Plug 'albfan/nerdtree-git-plugin'

Plug 'itchyny/lightline.vim'
Plug 'edkolev/tmuxline.vim'

Plug 'airblade/vim-gitgutter'
Plug 'ryanoasis/vim-devicons'

call plug#end()
filetype plugin on

