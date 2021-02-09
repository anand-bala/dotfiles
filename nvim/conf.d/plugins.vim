" File: plugins.vim
" Author: Anand Balakrishnan
" Description: Collection of plugins for my Vim config


" Platform portable way of setting the plugin download path
let s:is_win = has('win32') || has('win64')
let s:pluginpath = stdpath('data') . '/plugged'

call plug#begin(s:pluginpath)

" -- Sanity stuff
Plug 'ciaranm/securemodelines'
Plug 'editorconfig/editorconfig-vim'
" {{
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
" }}

" -- Everyday tools
Plug 'tpope/vim-obsession'
" Plug 'tpope/vim-commentary'
Plug 'tomtom/tcomment_vim'
" {{
" Disable secondary mappings for tcomment
let g:tcomment_mapleader1 = ''
let g:tcomment_mapleader2 = ''
" }}
Plug 'tpope/vim-abolish'

Plug 'andymass/vim-matchup'
Plug 'tpope/vim-surround'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-dispatch'

Plug 'godlygeek/tabular'

" Fuzzy search
if s:is_win && !has('win32unix')
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin --no-fish' }
endif
Plug 'junegunn/fzf.vim'
" {{{
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
let g:fzf_preview_window = ['right:50%', 'ctrl-/']
" }}}

" Floating Terminals
Plug 'voldikss/vim-floaterm'
" {{
let g:floaterm_shell = 'fish'
let g:floaterm_autoclose = 2
" }}

" File manager
Plug 'mcchrish/nnn.vim'
" {{{
let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }
" }}}

" -- Completions, Linting, and Snippets

Plug 'neovim/nvim-lspconfig'
" Plug 'nvim-lua/completion-nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'ojroques/nvim-lspfuzzy'

Plug 'SirVer/ultisnips'
" {{
let g:UltiSnipsEditSplit="vertical"
" }}

Plug 'honza/vim-snippets'
Plug 'hrsh7th/vim-vsnip'

" }}}

" ctags
Plug 'ludovicchabant/vim-gutentags'
" {{
let g:gutentags_ctags_extra_args = [
      \ '--tag-relative=yes',
      \ '--fields=+aimS',
      \ ]
let g:gutentags_file_list_command = {
      \ 'markers': {
      \   '.latexmkrc': 'fd -L -t f',
      \   '.git': 'fd -L -t f',
      \   '.hg': 'fd -L -t f',
      \ },
      \}
" }}

" -- Language specific
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}

Plug 'plasticboy/vim-markdown'
" {{
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_autowrite = 1
let g:vim_markdown_conceal = 1
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_edit_url_in = 'vsplit'
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_math = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_toml_frontmatter = 1
" }}

Plug 'mzlogin/vim-markdown-toc'

Plug 'ziglang/zig.vim'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'dag/vim-fish'

" -- UI stuff
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}
Plug 'kyazdani42/nvim-web-devicons'

Plug 'airblade/vim-gitgutter'

Plug 'dracula/vim', { 'as': 'dracula' }

call plug#end()
filetype plugin on
