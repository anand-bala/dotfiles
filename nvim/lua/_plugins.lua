local augroup = require("_utils").create_augroup

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

augroup("Packer", {
  [[BufWritePost init.lua PackerCompile]],
})

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
  use "tpope/vim-eunuch"
  use "tpope/vim-obsession"
  use "tpope/vim-abolish"
  use "andymass/vim-matchup"
  use "tpope/vim-surround"
  use "tpope/vim-fugitive"
  use {
    "tpope/vim-dispatch",
    opt = true,
    cmd = { "Dispatch", "Make", "Focus", "Start" },
  }
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
    requires = { { "nvim-lua/popup.nvim" }, { "nvim-lua/plenary.nvim" } },
  }
  ---]]
  ---[[ Floating Terminals
  use {
    "voldikss/vim-floaterm",
    config = function()
      if string.find(os.getenv "SHELL", "fish") ~= nil then
        vim.g.floaterm_shell = "fish"
      end
      vim.g.floaterm_autoclose = 2
    end,
  }
  ---]]
  ---]] Everyday tools

  ---[[ Completions, Linting, and Snippets

  use "neovim/nvim-lspconfig"
  use "williamboman/nvim-lsp-installer"

  use {
    "nvim-treesitter/nvim-treesitter",
    run = function()
      vim.cmd [[TSUpdate]]
    end,
    requires = {
      { "nvim-treesitter/playground", cmd = { "TSPlaygroundToggle" } },
    },
  }
  use { "L3MON4D3/LuaSnip", requires = { "rafamadriz/friendly-snippets" } }

  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "f3fora/cmp-spell",
      "quangnguyen30192/cmp-nvim-tags",
      "saadparwaiz1/cmp_luasnip",
      "ray-x/cmp-treesitter",
      "hrsh7th/cmp-emoji",
    },
  }

  ---[[ ctags
  use {
    "ludovicchabant/vim-gutentags",
    config = function()
      vim.g.gutentags_ctags_extra_args = { "--tag-relative=yes", "--fields=+aimS" }
      vim.g.gutentags_file_list_command = {
        markers = {
          ["root.tex"] = "fd -L -t f",
          ["main.tex"] = "fd -L -t f",
          [".latexmkrc"] = "fd -L -t f",
          [".git"] = "fd -L -t f",
          [".hg"] = "fd -L -t f",
        },
      }
    end,
  }
  ---]]
  ---]] Completions, Linting, and Snippets

  ---[[ Language specific
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
    end,
    ft = { "tex", "latex", "bib", "bibtex" },
  }
  use "KeitaNakamura/tex-conceal.vim"
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

  use "ziglang/zig.vim"
  use "rust-lang/rust.vim"
  use "cespare/vim-toml"
  use "dag/vim-fish"
  use "mboughaba/i3config.vim"
  use "JuliaEditorSupport/julia-vim"

  ---]] Language specific

  use {
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("gitsigns").setup {}
    end,
  }

  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end,
  }

  use {
    "famiu/feline.nvim",
    requires = { "kyazdani42/nvim-web-devicons", "SmiteshP/nvim-gps" },
    config = function()
      require("nvim-gps").setup()
    end,
  }
  use { "dracula/vim", as = "dracula" }
end

packer.startup {
  packer_init,
  config = packer_config,
}
