--- Setup telescope fuzzy finder
local telescope = require "telescope"

telescope.setup {
  defaults = {
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    sorting_strategy = "ascending",
    layout_strategy = "flex",
    layout_config = {
      prompt_position = "top",
      vertical = { prompt_position = "top" },
      horizontal = { prompt_position = "top" },
    },
    path_display = { shorten = 5 },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    mappings = require("_keymaps").telescope_mappings(),
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
}
require("telescope").load_extension "fzf"
