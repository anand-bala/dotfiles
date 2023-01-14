--- Fuzzy search
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      { "nvim-telescope/telescope-ui-select.nvim" },
    },
    cmd = "Telescope",
    config = function(_, opts)
      local telescope = require "telescope"

      telescope.setup {
        defaults = {
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
        pickers = {
          find_files = {
            find_command = { "fd", "--hidden", "-L", "--type", "file" },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
          },
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {},
          },
        },
      }

      telescope.load_extension "fzf"
      telescope.load_extension "ui-select"
    end,
  },
}
