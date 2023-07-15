--- Common dependencies
---@type LazyPluginSpec[]
local deps = {
  { "lewis6991/gitsigns.nvim", config = true },
  { "nvim-tree/nvim-web-devicons" },
}

--- UI elements
---@type LazyPluginSpec[]
local ui = {
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
    event = "VeryLazy",
    config = function()
      local notify = require "notify"
      notify.setup {
        top_down = false,
      }
      vim.notify = notify
    end,
  },
  {
    "luukvbaal/statuscol.nvim",
    config = function()
      local builtin = require "statuscol.builtin"
      require("statuscol").setup {
        relculright = true,
        segments = {
          { text = { "%s" }, click = "v:lua.ScSa" },
          {
            text = { builtin.lnumfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
          { text = { " ", builtin.foldfunc, " " }, click = "v:lua.ScFa" },
        },
      }
    end,
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPost",
    opts = {
      {
        char = "▏",
        char_blankline = "┆",
        buftype_exclude = { "terminal" },
        show_trailing_blankline_indent = false,
        show_current_context = true,
        filetype_exclude = { "help", "terminal" },
        -- disabled now for performance hit.
        -- use_treesitter = true
      },
    },
    config = function(_, opts)
      require("indent_blankline").setup(opts)
    end,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
  {
    "glepnir/lspsaga.nvim",
    cmd = { "Lspsaga" },
    event = { "BufReadPost" },
    config = function()
      require("lspsaga").setup {
        lightbulb = {
          enable = false,
        },
        ui = {
          -- This option only works in Neovim 0.9
          title = true,
          -- Border type can be single, double, rounded, solid, shadow.
          border = "single",
          winblend = 0,
          expand = "",
          collapse = "",
          code_action = "💡",
          incoming = " ",
          outgoing = " ",
          hover = " ",
          kind = {},
        },
      }
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
    },
  },
}

--- Treesitter
---@type LazyPluginSpec
local treesitter = {
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
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
}

return {
  treesitter,
  ui,
}
