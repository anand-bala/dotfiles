local pm_repo = "https://github.com/wbthomason/packer.nvim"
local install_path = table.concat(
  { vim.fn.stdpath "data", "site", "pack", "packer", "start", "packer.nvim" },
  "/"
)

local compile_path = table.concat(
  { vim.fn.stdpath "data", "site", "plugin", "packer_compiled.vim" },
  "/"
)

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.cmd(table.concat({ "!git clone", pm_repo, install_path }, " "))
end

local packer = require "packer"
local packer_config = {
  compile_path = compile_path,
  display = {
    open_fn = function()
      return require("packer.util").float { border = "single" }
    end,
  },
}

local packer_init = function()
  local use = packer.use
  -- Let packer manage itself
  use "wbthomason/packer.nvim"

  ---[[ Sanity stuff
  use "ciaranm/securemodelines"
  use {
    "tjdevries/astronauta.nvim",
    config = function()
      require "astronauta.keymap"
    end,
  }

  ---]]

  ---[[ Everyday tools
  use "tpope/vim-obsession"
  use "tpope/vim-abolish"
  use "andymass/vim-matchup"
  use "tpope/vim-fugitive"
  use { "junegunn/vim-easy-align", opt = true, cmd = { "EasyAlign" } }

  use {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  }

  ---[[ Fuzzy search
  use {
    "junegunn/fzf",
    run = function()
      -- First, we will run the install script
      vim.fn["fzf#install"]()
    end,
  }
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      "folke/trouble.nvim",
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
    config = function()
      require("trouble").setup {}
    end,
  }
  ---]]
  ---]] Everyday tools

  ---[[ Completions, Linting, and Snippets

  use "neovim/nvim-lspconfig"
  use "williamboman/nvim-lsp-installer"

  use {
    "nvim-treesitter/nvim-treesitter",
    run = [[:TSUpdate]],
  }
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "f3fora/cmp-spell",
      "quangnguyen30192/cmp-nvim-tags",
      "saadparwaiz1/cmp_luasnip",
      "ray-x/cmp-treesitter",
      "hrsh7th/cmp-emoji",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
  }
  ---]] Completions, Linting, and Snippets

  ---[[ Language specific
  use "folke/lua-dev.nvim"
  use { "rafcamlet/nvim-luapad", opt = true, cmd = { "Luapad" } }
  use {
    "lervag/vimtex",
    config = function()
      vim.g.vimtex_mappings_enabled = 0
      vim.g.vimtex_complete_enabled = 0
      vim.g.vimtex_view_enabled = 0
      vim.g.vimtex_format_enabled = 1
      vim.g.vimtex_toc_config = {
        split_pos = "botright",
      }
      vim.g.vimtex_syntax_conceal = {
        accents = 1,
        cites = 1,
        fancy = 1,
        greek = 1,
        math_bounds = 1,
        math_delimiters = 1,
        math_fracs = 1,
        math_super_sub = 1,
        math_symbols = 1,
        sections = 0,
        styles = 1,
      }
    end,
    ft = { "tex", "latex", "bib", "bibtex" },
  }
  use {
    "plasticboy/vim-markdown",
    config = function()
      vim.g.vim_markdown_auto_insert_bullets = 0
      vim.g.vim_markdown_autowrite = 1
      vim.g.vim_markdown_conceal = 1
      vim.g.vim_markdown_conceal_code_blocks = 0
      vim.g.vim_markdown_edit_url_in = "vsplit"
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_follow_anchor = 1
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_new_list_item_indent = 0
      vim.g.vim_markdown_strikethrough = 1
      vim.g.vim_markdown_toc_autofit = 1
      vim.g.vim_markdown_toml_frontmatter = 1
    end,
    ft = { "markdown" },
  }

  use {
    "ziglang/zig.vim",
    config = function()
      vim.g.zig_fmt_autosave = 0
    end,
  }
  use "rust-lang/rust.vim"

  ---]] Language specific

  use {
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup {}
    end,
  }

  use {
    "nvim-lualine/lualine.nvim",
    requires = {
      "kyazdani42/nvim-web-devicons",
      "SmiteshP/nvim-gps",
      "kdheepak/tabline.nvim",
    },
    config = function()
      require("nvim-gps").setup()
      require("tabline").setup { enable = false }
    end,
  }
  use { "dracula/vim", as = "dracula" }
end

packer.startup {
  packer_init,
  config = packer_config,
}
