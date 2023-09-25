---@diagnostic disable: missing-fields
--- Colorscheme
---
--- # My Colorblindness simulation
---
--- Source: https://daltonlens.org/evaluating-cvd-simulation/#Generating-Ishihara-like-plates-for-self-evaluation
---
--- | Plate method           | Protan | Deutan | Tritan |
--- | ---------------------- | ------ | ------ | ------ |
--- | Brettel 1997 sRGB      | 0.4    | 0.9    | 0.1    |
--- | Vischeck (Brettel CRT) | 0.3    | 0.9    | 0.1    |
--- | Viénot 1999 sRGB       | 0.4    | 0.9    | 0.1    |
--- | Machado 2009 sRGB      | 0.4    | 0.8    | 0.1    |
---
---@type LazyPluginSpec
local colorscheme = {
  "EdenEast/nightfox.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000,
  config = function(_, _)
    require("nightfox").setup {
      options = {
        colorblind = {
          enable = true,
          severity = {
            protan = 0.4,
            deutan = 1.0,
          },
        },
      },
    }

    vim.cmd "colorscheme dayfox"
  end,
}

--- Common dependencies
---@type LazyPluginSpec[]
local deps = {
  { "lewis6991/gitsigns.nvim", config = true },
  { "nvim-tree/nvim-web-devicons" },
}

---@type LazyPluginSpec[]
return {
  colorscheme,
  { "folke/neodev.nvim" },
  {
    "folke/which-key.nvim",
    lazy = false,
    opts = {
      plugins = {
        registers = false,
      },
    },
  },
  {
    --- Project local settings
    "folke/neoconf.nvim",
    event = "BufReadPre",
    opts = {
      import = {
        vscode = false, -- local .vscode/settings.json
        coc = false, -- global/local coc-settings.json
        nlsp = false, -- global/local nlsp-settings.nvim json settings
      },
    },
  },
  { "tpope/vim-obsession", cmd = "Obsession" },
  {
    "tpope/vim-abolish",
    cmd = { "Abolish", "Subvert", "S" },
    keys = {
      { "crs", desc = "coerce to snake_case" },
      { "crm", desc = "coerce to MixedCase" },
      { "crc", desc = "coerce to camelCase" },
      { "cru", desc = "coerce to UPPER_CASE" },
      { "cr-", desc = "coerce to dash-case" },
      { "cr.", desc = "coerce to dot.case" },
    },
  },
  { "tpope/vim-fugitive", cmd = "Git" },
  { "junegunn/vim-easy-align", cmd = { "EasyAlign" } },
  { "echasnovski/mini.comment", event = "VeryLazy", opts = {} },
  {
    "andymass/vim-matchup",
    lazy = false,
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "status" }
      vim.g.matchup_override_vimtex = 1
      vim.g.matchup_surround_enabled = 1
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = [[:TSUpdate]],
    event = "BufReadPost",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "html",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rust",
        "vim",
        "vimdoc",
        "zig",
      },
      highlight = { enable = true },
      indent = { enable = true },
      matchup = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  { "stevearc/dressing.nvim", event = "VeryLazy", opts = {} },
  {
    "echasnovski/mini.tabline",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "]b", "<cmd>bnext<cr>", desc = "Move to next buffer in list" },
      { "[b", "<cmd>bprevious<cr>", desc = "Move to previous buffer in list" },
    },
    dependencies = deps,
  },
  {
    "echasnovski/mini.statusline",
    event = "VeryLazy",
    opts = {
      set_vim_settings = true,
    },
    init = function(_)
      -- Turn on global statusline
      vim.opt.laststatus = 3
      -- Turn on sign column
      vim.wo.signcolumn = "yes"
    end,
    dependencies = deps,
  },
  {
    "rcarriga/nvim-notify",
    lazy = false,
    config = function()
      local notify = require "notify"
      ---@diagnostic disable-next-line: missing-fields
      notify.setup {
        -- top_down = false,
      }
      vim.notify = notify
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    config = function()
      vim.g.indent_blankline_char = "┆"
      vim.g.indent_blankline_char_blankline = "┆"
      vim.g.indent_blankline_show_trailing_blankline_indent = false
      vim.g.indent_blankline_show_current_context = true
      -- disabled now for performance hit.
      vim.g.indent_blankline_use_treesitter = true
      require("indent_blankline").setup {}
    end,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
}
