local utils = require('_utils')

local pm_repo = 'https://github.com/wbthomason/packer.nvim'
local install_path = vim.fn.stdpath('data') ..
                         '/site/pack/packer/opt/packer.nvim'
local compile_path = utils.join_paths(vim.fn.stdpath('data'), 'site', 'plugin',
                                      'packer_compiled.vim')

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.cmd(table.concat({"!git clone", pm_repo, install_path}, ' '))
end

local packer = nil

local init = function()
    if packer == nil then
        packer = require('packer')
        packer.init({
            disable_commands = true,
            ensure_dependencies = true,
            compile_path = compile_path,
            display = {
                open_fn = function()
                    return require('packer.util').float({border = 'single'})
                end
            }
        })
    end

    local use = packer.use
    -- Let packer manage itself
    use {'wbthomason/packer.nvim', opt = true}

    ---[[ Sanity stuff
    use 'ciaranm/securemodelines'
    use 'tjdevries/astronauta.nvim'
    ---]]

    ---[[ Everyday tools
    use 'tpope/vim-eunuch'
    use 'tpope/vim-obsession'
    use 'tpope/vim-abolish'
    use 'andymass/vim-matchup'
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive'
    use {
        'tpope/vim-dispatch',
        opt = true,
        cmd = {'Dispatch', 'Make', 'Focus', 'Start'}
    }
    use {'junegunn/vim-easy-align', opt = true, cmd = {'EasyAlign'}}

    use {
        'tomtom/tcomment_vim',
        config = function()
            -- Disable secondary mappings for tcomment
            vim.g.tcomment_mapleader1 = ''
            vim.g.tcomment_mapleader2 = ''
        end
    }

    ---[[ Fuzzy search
    use {
        'nvim-telescope/telescope.nvim',
        requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
    }
    ---]]
    ---[[ Floating Terminals
    use {
        'voldikss/vim-floaterm',
        config = function()
            if string.find(os.getenv("SHELL"), "fish") ~= nil then
                vim.g.floaterm_shell = 'fish'
            end
            vim.g.floaterm_autoclose = 2
        end
    }
    ---]]
    ---]] Everyday tools

    ---[[ Completions, Linting, and Snippets

    use 'neovim/nvim-lspconfig'
    use 'kabouzeid/nvim-lspinstall'

    use 'hrsh7th/nvim-compe'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function() vim.cmd [[TSUpdate]] end
    }

    use 'rafamadriz/friendly-snippets'
    use 'honza/vim-snippets'
    use {
        'SirVer/ultisnips',
        config = function() vim.g.UltiSnipsEditSplit = "vertical" end
    }
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/vim-vsnip-integ'
    ---[[ ctags
    use {
        'ludovicchabant/vim-gutentags',
        config = function()
            vim.g.gutentags_ctags_extra_args = {
                '--tag-relative=yes', '--fields=+aimS'
            }
            vim.g.gutentags_file_list_command = {
                markers = {
                    ["root.tex"] = 'fd -L -t f',
                    ["main.tex"] = 'fd -L -t f',
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
    use {
        'lervag/vimtex',
        config = function()
            vim.g.vimtex_mappings_enabled = 0
            vim.g.vimtex_complete_enabled = 0
            vim.g.vimtex_view_enabled = 0
            vim.g.vimtex_format_enabled = 1
        end,
        ft = {'tex', 'latex', 'bib', 'bibtex'}
    }
    -- use 'KeitaNakamura/tex-conceal.vim'
    use {
        'plasticboy/vim-markdown',
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
        ft = {'markdown'}
    }

    use 'ziglang/zig.vim'
    use 'rust-lang/rust.vim'
    use 'cespare/vim-toml'
    use 'dag/vim-fish'
    use 'mboughaba/i3config.vim'

    ---]] Language specific

    use {
        'lewis6991/gitsigns.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = function() require('gitsigns').setup() end
    }
    use {
        'glepnir/galaxyline.nvim',
        branch = 'main',
        requires = {'kyazdani42/nvim-web-devicons'}
    }
    use {'dracula/vim', as = 'dracula'}
end

_G.Plugins = setmetatable({}, {
    __index = function(_, key)
        vim.cmd [[packadd packer.nvim]]
        init()
        return packer[key]
    end
})

vim.cmd [[command! PackerInstall lua Plugins.install()]]
vim.cmd [[command! PackerUpdate  lua Plugins.update()]]
vim.cmd [[command! PackerSync    lua Plugins.sync()]]
vim.cmd [[command! PackerClean   lua Plugins.clean()]]
vim.cmd [[command! PackerCompile lua Plugins.compile()]]
