return {
  {
    "rcarriga/nvim-notify",
    config = function()
      local notify = require "notify"
      notify.setup {
        top_down = false,
      }
      vim.notify = notify
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = true,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = {
      "kyazdani42/nvim-web-devicons",
      { "kdheepak/tabline.nvim", opts = { enable = false } },
    },
    opts = function()
      local tb = require "tabline"
      vim.keymap.set("n", "bt", tb.buffer_next, { silent = true, remap = false })
      vim.keymap.set("n", "bT", tb.buffer_previous, { silent = true, remap = false })
      return {
        options = {
          theme = "auto",
          component_separators = "|",
          section_separators = "",
        },
        sections = {
          lualine_a = { { "mode", right_padding = 2 } },
          lualine_b = {
            {
              "filetype",
              separator = "",
              padding = { left = 1, right = 0 },
              colored = false, -- displays filetype icon in color if set to `true
              icon_only = true, -- Display only icon for filetype
            },
            "filename",
          },
          lualine_c = {},
          lualine_x = {
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              sections = { "error", "warn", "info", "hint" },
            },
          },
          lualine_y = { "progress" },
          lualine_z = { { "location", left_padding = 2 } },
        },
        inactive_sections = {
          lualine_a = { "filename" },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { "location" },
        },
        tabline = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { tb.tabline_buffers },
          lualine_x = { { tb.tabline_tabs, padding = { left = 0, right = 0 } } },
          lualine_y = {},
          lualine_z = {
            "branch",
            {
              function()
                return vim.fn.ObsessionStatus("壘", "")
              end,
            },
          },
        },
        extensions = {},
      }
    end,
  },
}
