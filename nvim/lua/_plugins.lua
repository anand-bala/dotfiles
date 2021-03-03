--- File:   plugins.lua
--- Authr:  Anand Balakrishnan
local g = vim.g
local execute = vim.api.nvim_command
local utils = require '_utils'

--- Bootstrap paq-nvim if not present
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/opt/paq-nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/savq/paq-nvim.git ' .. install_path)
end
--- Load paq-nvim
vim.cmd 'packadd paq-nvim' -- Load package
local paq = require'paq-nvim'.paq -- Import module and bind `paq` function
paq {'savq/paq-nvim', opt = true} -- Let Paq manage itself

---[[ Sanity stuff
paq 'ciaranm/securemodelines'
---[[
paq 'editorconfig/editorconfig-vim'
g.EditorConfig_exclude_patterns = {"fugitive://.*"}
---]]
---]]

---[[ Everyday tools
paq 'tpope/vim-obsession'
---[[
paq 'tomtom/tcomment_vim'
-- Disable secondary mappings for tcomment
g.tcomment_mapleader1 = ''
g.tcomment_mapleader2 = ''
---]]
paq 'tpope/vim-abolish'

paq 'andymass/vim-matchup'
paq 'tpope/vim-surround'

paq 'tpope/vim-fugitive'
paq 'tpope/vim-dispatch'

paq 'godlygeek/tabular'

--- Fuzzy search
if utils.is_win() then
    paq {'junegunn/fzf', run = vim.fn["fzf#install"]}
else
    paq {'junegunn/fzf', run = './install --bin --no-fish'}
end
---[[
paq 'junegunn/fzf.vim'
g.fzf_layout = {window = {width = 0.9, height = 0.6}}
g.fzf_preview_window = {'right:50%', 'ctrl-/'}
---]]

--- Floating Terminals
---[[
paq 'voldikss/vim-floaterm'
g.floaterm_shell = 'fish'
g.floaterm_autoclose = 2
---]]

--- File manager
---[[
paq 'mcchrish/nnn.vim'
g["nnn#layout"] = {window = {width = 0.9, height = 0.6, highlight = 'Debug'}}
---]]
---]] Everyday tools

---[[ Completions, Linting, and Snippets

paq 'neovim/nvim-lspconfig'
paq 'hrsh7th/nvim-compe'
paq 'nvim-treesitter/nvim-treesitter'
paq 'ojroques/nvim-lspfuzzy'

---[[
paq 'SirVer/ultisnips'
g.UltiSnipsEditSplit = "vertical"
---]]

paq 'honza/vim-snippets'
paq 'hrsh7th/vim-vsnip'

--- ctags
---[[
paq 'ludovicchabant/vim-gutentags'
g.gutentags_ctags_extra_args = {'--tag-relative=yes', '--fields=+aimS'}
g.gutentags_file_list_command = {
    markers = {
        [".latexmkrc"] = 'fd -L -t f',
        ['.git'] = 'fd -L -t f',
        ['.hg'] = 'fd -L -t f'
    }
}
---]]
---]] Completions, Linting, and Snippets

---[[ Language specific
paq 'KeitaNakamura/tex-conceal.vim'
---[[
paq 'plasticboy/vim-markdown'
g.vim_markdown_auto_insert_bullets = 0
g.vim_markdown_autowrite = 1
g.vim_markdown_conceal = 1
g.vim_markdown_conceal_code_blocks = 0
g.vim_markdown_edit_url_in = 'vsplit'
g.vim_markdown_folding_disabled = 1
g.vim_markdown_follow_anchor = 1
g.vim_markdown_frontmatter = 1
g.vim_markdown_math = 1
g.vim_markdown_new_list_item_indent = 0
g.vim_markdown_strikethrough = 1
g.vim_markdown_toc_autofit = 1
g.vim_markdown_toml_frontmatter = 1
---]]
paq 'mzlogin/vim-markdown-toc'
paq 'ziglang/zig.vim'
paq 'rust-lang/rust.vim'
paq 'cespare/vim-toml'
paq 'dag/vim-fish'

---]] Language specific

paq 'kyazdani42/nvim-web-devicons'
paq 'mhinz/vim-signify'
paq {'glepnir/galaxyline.nvim', branch = 'main'}
paq {'dracula/vim', as = 'dracula'}

-- --- Install the stuff
-- Pq.install()
-- Pq.update()
-- Pq.clean()
