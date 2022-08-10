local M = {}

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

  ---[[ Everyday tools
  use "tpope/vim-obsession"
  use "tpope/vim-abolish"
  use {
    "andymass/vim-matchup",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  }
  use "tpope/vim-fugitive"
  use { "junegunn/vim-easy-align", opt = true, cmd = { "EasyAlign" } }

  use {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  }
  use "nvim-lua/plenary.nvim"

  ---[[ Fuzzy search
  use {
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
  }
  ---]]
  ---]] Everyday tools

  ---[[ Completions, Linting, and Snippets

  use "neovim/nvim-lspconfig"
  use "williamboman/nvim-lsp-installer"

  use {
    "nvim-treesitter/nvim-treesitter",
    run = [[:TSUpdate]],
    requires = {
      { "nvim-treesitter/playground", opt = true, cmd = { "TSPlaygroundToggle" } },
    },
  }
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-calc",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-omni",
      "hrsh7th/cmp-path",
      "f3fora/cmp-spell",
      "quangnguyen30192/cmp-nvim-tags",
      "ray-x/cmp-treesitter",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
  }
  ---]] Completions, Linting, and Snippets

  ---[[ Language specific
  -- Lua Dev
  use "folke/lua-dev.nvim"
  -- Tex/Markdown
  use { "lervag/vimtex", ft = { "tex", "latex", "bib", "bibtex" } }
  use { "preservim/vim-markdown", ft = { "markdown" } }
  -- Rust
  use "rust-lang/rust.vim"
  use "simrat39/rust-tools.nvim"
  -- Kitty.conf
  use "fladson/vim-kitty"
  ---]] Language specific

  ---[[ Writing Helpers
  use {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup()
    end,
  }
  ---]] Writing Helpers

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
  }
  use "olimorris/onedarkpro.nvim"
  use "shaunsingh/solarized.nvim"
end

function M.setup()
  packer.startup {
    packer_init,
    config = packer_config,
  }
end

return M
