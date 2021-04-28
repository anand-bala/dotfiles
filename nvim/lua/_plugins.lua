local utils = require('_utils')

local paq_repo = 'https://github.com/savq/paq-nvim.git'
local install_path = vim.fn.stdpath('data') .. '/site/pack/paqs/opt/paq-nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.cmd(table.concat({"!git clone", paq_repo, install_path}, ' '))
end

vim.cmd [[packadd paq-nvim]]

local paq = require'paq-nvim'.paq -- Import module and bind `paq` function

-- Let paq manage itself
paq {'savq/paq-nvim', opt = true}

---[[ Sanity stuff
paq 'ciaranm/securemodelines'
paq 'editorconfig/editorconfig-vim'
vim.g.EditorConfig_exclude_patterns = {"fugitive://.*"}
---]]

---[[ Everyday tools
paq 'tpope/vim-obsession'
paq 'tpope/vim-abolish'
paq 'andymass/vim-matchup'
paq 'tpope/vim-surround'
paq 'tpope/vim-repeat'
paq 'tpope/vim-fugitive'
paq 'tpope/vim-dispatch'
paq 'junegunn/vim-easy-align'

paq 'tomtom/tcomment_vim'
-- Disable secondary mappings for tcomment
vim.g.tcomment_mapleader1 = ''
vim.g.tcomment_mapleader2 = ''

---[[ Common Dependencies
paq 'nvim-lua/popup.nvim'
paq 'nvim-lua/plenary.nvim'
---]]

paq 'nvim-telescope/telescope.nvim' -- Fuzzy search

---[[ Floating Terminals
paq 'voldikss/vim-floaterm'
if string.find(os.getenv("SHELL"), "fish") ~= nil then
    vim.g.floaterm_shell = 'fish'
end
vim.g.floaterm_autoclose = 2
---]]
---]] Everyday tools

---[[ Completions, Linting, and Snippets

paq 'neovim/nvim-lspconfig'
paq 'hrsh7th/nvim-compe'
paq {
    'nvim-treesitter/nvim-treesitter',
    run = function() vim.cmd [[TSUpdate]] end
}

paq 'rafamadriz/friendly-snippets'
paq 'honza/vim-snippets'
paq 'SirVer/ultisnips'
vim.g.UltiSnipsEditSplit = "vertical"
paq 'hrsh7th/vim-vsnip'
paq 'hrsh7th/vim-vsnip-integ'
---[[ ctags
paq 'ludovicchabant/vim-gutentags'
vim.g.gutentags_ctags_extra_args = {'--tag-relative=yes', '--fields=+aimS'}
vim.g.gutentags_file_list_command = {
    markers = {
        ["root.tex"] = 'fd -L -t f',
        ["main.tex"] = 'fd -L -t f',
        [".latexmkrc"] = 'fd -L -t f',
        ['.git'] = 'fd -L -t f',
        ['.hg'] = 'fd -L -t f'
    }
}
---]]
---]] Completions, Linting, and Snippets

---[[ Language specific
paq {'KeitaNakamura/tex-conceal.vim', opt = true}
vim.cmd [[autocmd Filetype tex,latex,bib packadd! tex-conceal.vim]]

paq 'plasticboy/vim-markdown'
vim.g.vim_markdown_auto_insert_bullets = 0
vim.g.vim_markdown_autowrite = 1
vim.g.vim_markdown_conceal = 1
vim.g.vim_markdown_conceal_code_blocks = 0
vim.g.vim_markdown_edit_url_in = 'vsplit'
vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_follow_anchor = 1
vim.g.vim_markdown_frontmatter = 1
vim.g.vim_markdown_math = 1
vim.g.vim_markdown_new_list_item_indent = 0
vim.g.vim_markdown_strikethrough = 1
vim.g.vim_markdown_toc_autofit = 1
vim.g.vim_markdown_toml_frontmatter = 1

paq 'ziglang/zig.vim'
paq 'rust-lang/rust.vim'
paq 'cespare/vim-toml'
paq 'dag/vim-fish'
paq 'mboughaba/i3config.vim'

---]] Language specific

paq 'kyazdani42/nvim-web-devicons'
paq 'lewis6991/gitsigns.nvim'
require('gitsigns').setup()

paq 'glepnir/galaxyline.nvim'
paq {'dracula/vim', as = 'dracula'}
