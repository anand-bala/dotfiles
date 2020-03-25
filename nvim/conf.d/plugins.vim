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

Plug 'vim-scripts/utl.vim'

Plug 'tpope/vim-abolish'
Plug 'arthurxavierx/vim-caser'

Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-easy-align'
" {{
let g:easy_align_bypass_fold = 1

nmap ga <plug>(LiveEasyAlign)
vmap ga <plug>(LiveEasyAlign)
nmap gA <plug>(EasyAlign)
vmap gA <plug>(EasyAlign)
vmap .  <plug>(EasyAlignRepeat)
" }}
Plug 'andymass/vim-matchup'

Plug 'tpope/vim-speeddating'

Plug 'preservim/nerdcommenter'
" {{
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" }}

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" {{
nnoremap <C-f> :Files<Cr>
nnoremap <C-g> :Rg<Cr>

let g:fzf_layout = { 'down': '~40%' }
" }}

" -- Completions, Linting, and Snippets

" Plug 'SirVer/ultisnips'
" " {{
" let g:UltiSnipsExpandTrigger = '<nop>'
" let g:UltiSnipsJumpForwardTrigger = '<c-j>'
" let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
" let g:UltiSnipsRemoveSelectModeMappings = 0
" " }}
Plug 'honza/vim-snippets'

Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc-sources'

" ctags
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'

" -- Language specific
Plug 'lervag/vimtex'

Plug 'plasticboy/vim-markdown'
Plug 'mzlogin/vim-markdown-toc'

Plug 'rust-lang/rust.vim'
" {{
let g:autofmt_autosave = 1
" }}

Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'

" Shell Support
Plug 'dag/vim-fish'
Plug 'pprovost/vim-ps1'

" -- UI stuff

Plug 'preservim/nerdtree'
Plug 'albfan/nerdtree-git-plugin'

Plug 'liuchengxu/eleline.vim'

Plug 'airblade/vim-gitgutter'
Plug 'ryanoasis/vim-devicons'

call plug#end()
filetype plugin on

