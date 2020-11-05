" File: plugins.vim
" Author: Anand Balakrishnan
" Description: Collection of plugins for my Vim config


" Platform portable way of setting the plugin download path
let pluginpath = stdpath('data') . '/plugged'
call plug#begin(pluginpath)

" -- Sanity stuff
Plug 'ciaranm/securemodelines'
Plug 'editorconfig/editorconfig-vim'
" {{
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
" }}

" -- Everyday tools
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-abolish'

Plug 'andymass/vim-matchup'
Plug 'tpope/vim-surround'

Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'

Plug 'godlygeek/tabular'

" Fuzzy search
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin --no-fish' }
Plug 'junegunn/fzf.vim'

" -- Completions, Linting, and Snippets

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'dense-analysis/ale'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'
" }}}

" ctags
Plug 'ludovicchabant/vim-gutentags'
Plug 'liuchengxu/vista.vim'

" -- Language specific

Plug 'plasticboy/vim-markdown'
Plug 'mzlogin/vim-markdown-toc'

Plug 'ziglang/zig.vim'
Plug 'rust-lang/rust.vim'
" {{
let g:autofmt_autosave = 1
" }}

Plug 'JuliaEditorSupport/julia-vim'
" {{
let g:latex_to_unicode_tab = 0
let g:latex_to_unicode_suggestions = 0
let g:latex_to_unicode_auto = 1
" }}
Plug 'kdheepak/JuliaFormatter.vim'

Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'

Plug 'dag/vim-fish'

" -- UI stuff
Plug 'justinmk/vim-dirvish'
Plug 'kristijanhusak/vim-dirvish-git'
Plug 'itchyny/lightline.vim'

Plug 'airblade/vim-gitgutter'
Plug 'ryanoasis/vim-devicons'

call plug#end()
filetype plugin on

