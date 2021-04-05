local execute = vim.api.nvim_command
local fn = vim.fn
local utils = require('_utils')

local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    execute('!git clone https://github.com/wbthomason/packer.nvim ' ..
                install_path)
    execute 'packadd packer.nvim'
end

local packer = require('packer')
local compile_path = utils.join_paths(vim.fn.stdpath('data'),
                                      'site/pack/loader/start/packer/plugin/',
                                      'packer_compiled.vim')

local init = function()
    local use = require('packer').use
    -- Let packer manage itself
    use 'wbthomason/packer.nvim'

    ---[[ Sanity stuff
    use 'ciaranm/securemodelines'
    ---[[
    use {
        'editorconfig/editorconfig-vim',
        config = function()
            vim.g.EditorConfig_exclude_patterns = {"fugitive://.*"}
        end
    }
    ---]]
    ---]]

    ---[[ Everyday tools
    use 'tpope/vim-obsession'
    ---[[
    use {
        'tomtom/tcomment_vim',
        config = function()
            -- Disable secondary mappings for tcomment
            vim.g.tcomment_mapleader1 = ''
            vim.g.tcomment_mapleader2 = ''
        end
    }
    ---]]
    use 'tpope/vim-abolish'

    use 'andymass/vim-matchup'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'

    use {'tpope/vim-fugitive', opt = true, cmd = {'Git'}}
    use {
        'tpope/vim-dispatch',
        opt = true,
        cmd = {'Dispatch', 'Make', 'Focus', 'Start'}
    }

    use 'junegunn/vim-easy-align'

    --- Fuzzy search
    ---[[

    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }
    ---]]

    --- Floating Terminals
    ---[[
    use {
        'voldikss/vim-floaterm',
        config = function()
            vim.g.floaterm_shell = 'fish'
            vim.g.floaterm_autoclose = 2
        end
    }
    ---]]

    --- File manager
    ---[[
    -- use {
    --     'mcchrish/nnn.vim',
    --     config = function()
    --         vim.g["nnn#layout"] = {
    --             window = {width = 0.9, height = 0.6, highlight = 'Debug'}
    --         }
    --     end
    -- }
    ---]]
    ---]] Everyday tools

    ---[[ Completions, Linting, and Snippets

    use 'neovim/nvim-lspconfig'
    use 'hrsh7th/nvim-compe'
    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

    ---[[
    use {
        'SirVer/ultisnips',
        config = function() vim.g.UltiSnipsEditSplit = "vertical" end
    }
    ---]]
    -- use 'honza/vim-snippets'
    use {
        'hrsh7th/vim-vsnip',
        requires = {'hrsh7th/vim-vsnip-integ', 'rafamadriz/friendly-snippets'}
    }
    --- ctags
    ---[[
    use {
        'ludovicchabant/vim-gutentags',
        config = function()
            vim.g.gutentags_ctags_extra_args =
                {'--tag-relative=yes', '--fields=+aimS'}
            vim.g.gutentags_file_list_command =
                {
                    markers = {
                        [".latexmkrc"] = 'fd -L -t f',
                        ['.git'] = 'fd -L -t f',
                        ['.hg'] = 'fd -L -t f'
                    }
                }
        end
    }
    ---]]
    ---]] Completions, Linting, and Snippets

    ---[[ Language specific
    use {'KeitaNakamura/tex-conceal.vim', ft = {'tex', 'latex', 'bib'}}
    ---[[
    use {
        'plasticboy/vim-markdown',
        ft = 'markdown',
        config = function()
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
        end,
        requires = 'mzlogin/vim-markdown-toc'
    }
    ---]]

    use {'ziglang/zig.vim', ft = 'zig'}
    use {'rust-lang/rust.vim', ft = 'rust'}
    use {'cespare/vim-toml', ft = 'toml'}
    use {'dag/vim-fish', ft = 'toml'}
    use {'mboughaba/i3config.vim', ft = 'i3config'}

    ---]] Language specific

    use 'kyazdani42/nvim-web-devicons'
    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function() require('gitsigns').setup() end
    }
    use {'glepnir/galaxyline.nvim', branch = 'main'}
    use {'dracula/vim', as = 'dracula'}
end

packer.startup({
    init,
    config = {ensure_dependencies = true, compile_path = compile_path}
})
