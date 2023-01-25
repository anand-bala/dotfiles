-- Common dependencies
local deps = {
  { "lewis6991/gitsigns.nvim", config = true },
  "kyazdani42/nvim-web-devicons",
}
-- Colorscheme
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

-- Statusline and tabline
local bars = {
  {
    "echasnovski/mini.tabline",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "]b", "<cmd>bnext<cr>", desc = "Move to next buffer in list" },
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
      -- Customize left column
      vim.opt.statuscolumn = "%= "
          .. "%#SignColumn#"
          .. "%s"
          .. "%= "
          .. "%*"
          .. "%#LineNr#"
          .. "%{%"
          .. "&number ? "
          .. 'printf("%"..len(line("$")).."s", v:lnum)'
          .. ":"
          .. '""'
          .. "%}"
          .. "%= "
          .. "%*"
          .. "%#FoldColumn#" -- highlight group for fold
          .. "%{" -- expression for showing fold expand/colapse
          .. "foldlevel(v:lnum) > foldlevel(v:lnum - 1)" -- any folds?
          .. "? (foldclosed(v:lnum) == -1" -- currently open?
          .. '? ""' -- point down
          .. ':  ""' -- point to right
          .. ")"
          .. ': " "' -- blank for no fold, or inside fold
          .. "}"
          .. "%="
          .. "%*"
    end,
    config = function(_, opts)
      require("mini.statusline").setup(opts)
    end,
    dependencies = deps,
  },
}

-- Notifications
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

-- Treesitter
local treesitter = {
  "nvim-treesitter/nvim-treesitter",
  build = [[:TSUpdate]],
  event = "BufReadPost",
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "help",
      "html",
      "lua",
      "markdown",
      "markdown_inline",
      "python",
      "regex",
      "rust",
      "vim",
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
}

-- Folding
local folding = {
  "kevinhwang91/nvim-ufo",
  dependencies = { "kevinhwang91/promise-async" },
  lazy = false,
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
    vim.opt.foldcolumn = "auto:3"
  end,
  config = function()
    local ftMap = {
      git = "",
    }

    local function customizeSelector(bufnr)
      local function handleFallbackException(err, providerName)
        if type(err) == "string" and err:match "UfoFallbackException" then
          return require("ufo").getFolds(bufnr, providerName)
        else
          return require("promise").reject(err)
        end
      end

      return require("ufo")
          .getFolds(bufnr, "lsp")
          :catch(function(err)
            return handleFallbackException(err, "treesitter")
          end)
          :catch(function(err)
            return handleFallbackException(err, "indent")
          end)
    end

    require("ufo").setup {
      provider_selector = function(_, filetype, _)
        return ftMap[filetype] or customizeSelector
      end,
    }
  end,
}

return {
  colorscheme,
  bars,
  notifications,
  treesitter,
  folding,
}
