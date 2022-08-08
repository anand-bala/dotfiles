local ok, lualine = pcall(require, "lualine")

if not ok then
  return
end
local gps = require "nvim-gps"
local tb = require "tabline"

gps.setup()
tb.setup { enable = false }

lualine.setup {
  options = {
    theme = "onedarkpro",
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
    lualine_c = { { gps.get_location, cond = gps.is_available } },
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
