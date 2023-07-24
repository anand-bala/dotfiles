--- Colorscheme
---@type LazyPluginSpec
local colorscheme = {
  "rose-pine/neovim",
  name = "rose-pine",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000,
  config = function()
    vim.opt.background = "light"
    vim.cmd [[colorscheme rose-pine]]
  end,
}

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
    event = "BufReadPre",
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
    event = "BufReadPre",
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
  event = "BufReadPre",
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

---@type LazyPluginSpec[]
return {
  colorscheme,
  ui,
  "folke/neodev.nvim",
  {
    "folke/which-key.nvim",
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
    -- opts = {
    --   import = {
    --     vscode = false, -- local .vscode/settings.json
    --     coc = false, -- global/local coc-settings.json
    --     nlsp = false, -- global/local nlsp-settings.nvim json settings
    --   },
    -- },
    config = true,
  },
  { "tpope/vim-obsession", cmd = "Obsession" },
  { "tpope/vim-abolish", lazy = false },
  { "tpope/vim-fugitive", cmd = "Git" },
  { "junegunn/vim-easy-align", cmd = { "EasyAlign" } },
  { "echasnovski/mini.comment", event = "VeryLazy", opts = {} },
  treesitter,
}
