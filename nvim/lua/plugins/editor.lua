--- Common dependencies
---@type LazyPluginSpec[]
local deps = {
  { "lewis6991/gitsigns.nvim",    config = true },
  { "nvim-tree/nvim-web-devicons" },
}

--- Selection UI
---@type LazyPluginSpec
local select_ui = {
  "stevearc/dressing.nvim",
  event = "VeryLazy",
  opts = {
    select = {
      backend = { "builtin" },
    },
  },
}

--- Colorscheme
---@type LazyPluginSpec
local colorscheme = {
  "shaunsingh/solarized.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000,
  config = function()
    vim.g.solarized_borders = true
    vim.opt.background = "light"
    vim.cmd [[colorscheme solarized]]
  end,
}

--- Statusline and tabline
---@type LazyPluginSpec[]
local bars = {
  {
    "echasnovski/mini.tabline",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "]b", "<cmd>bnext<cr>",     desc = "Move to next buffer in list" },
      { "[b", "<cmd>bprevious<cr>", desc = "Move to previous buffer in list" },
    },
    config = function(_, opts)
      require("mini.tabline").setup(opts or {})
    end,
    dependencies = deps,
  },
  {
    "echasnovski/mini.statusline",
    event = "VeryLazy",
    opts = {
      set_vim_settings = false,
    },
    init = function(_)
      -- Turn on global statusline
      vim.opt.laststatus = 3
      -- Turn on sign column
      vim.wo.signcolumn = "yes"
    end,
    config = function(_, opts)
      require("mini.statusline").setup(opts)
    end,
    dependencies = deps,
  },
}

--- Notifications
---@type LazyPluginSpec
local notifications = {
  "rcarriga/nvim-notify",
  event = "VeryLazy",
  config = function()
    local notify = require "notify"
    notify.setup {
      top_down = false,
    }
    vim.notify = notify
  end,
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
    highlight = {
      enable = true,
      disable = { "latex", "tex" },
    },
    indent = { enable = true, disable = { "python" } },
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
  end,
  dependencies = {
    "IndianBoy42/tree-sitter-just",
    config = true,
  },
}

--- Folding
---@type LazyPluginSpec
local folding = {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
    {
      "luukvbaal/statuscol.nvim",
      config = function()
        local builtin = require "statuscol.builtin"
        require("statuscol").setup {
          relculright = true,
          segments = {
            { text = { "%s" },                       click = "v:lua.ScSa" },
            { text = { builtin.lnumfunc },           click = "v:lua.ScLa" },
            { text = { " ", builtin.foldfunc, " " }, click = "v:lua.ScFa" },
          },
        }
      end,
    },
  },
  event = "BufReadPost",
  keys = {
    {
      "zr",
      function()
        require("ufo").openFoldsExceptKinds()
      end,
      "n",
    },
    {
      "zR",
      function()
        require("ufo").openAllFolds()
      end,
      "n",
    },
    {
      "zM",
      function()
        require("ufo").closeAllFolds()
      end,
      "n",
    },
    {
      "zm",
      function()
        require("ufo").closeFoldsWith()
      end,
      "n",
    },
  },
  init = function(_)
    -- Setup folds
    vim.opt.foldenable = true
    vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
    vim.opt.foldlevelstart = 99
    vim.opt.fillchars = { fold = " ", foldopen = "", foldclose = "" }
    vim.opt.foldcolumn = "1"
  end,
  config = function()
    -- treesitter as a main provider instead
    -- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
    -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
    require("ufo").setup {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    }
  end,
}

--- Indent configuration
---@type LazyPluginSpec
local indent = {
  "lukas-reineke/indent-blankline.nvim",
  event = "BufReadPost",
  opts = {
    {
      char = "▏",
      buftype_exclude = { "terminal" },
      show_trailing_blankline_indent = false,
      show_current_context = true,
      filetype_exclude = { "help", "terminal" },
      -- default : {'class', 'function', 'method'}
      context_patterns = {
        "class",
        "function",
        "method",
        "^if",
        "^while",
        "^for",
        "^object",
        "^table",
        "^type",
        "^import",
        "block",
        "arguments",
      },
      -- disabled now for performance hit.
      -- use_treesitter = true
    },
  },
  config = function(_, opts)
    require("indent_blankline").setup(opts)
  end,
}

return {
  colorscheme,
  bars,
  notifications,
  treesitter,
  folding,
  indent,
  select_ui,
}
