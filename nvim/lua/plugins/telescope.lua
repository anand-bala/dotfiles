--- Fuzzy search

--- Mappings for telescope.nvim
local function telescope_mappings()
  local command = vim.api.nvim_create_user_command

  local mappings = {
    i = {
      ["<C-u>"] = false,
      ["<C-d>"] = false,
    },
  }
  command("Helptags", "Telescope help_tags", { force = true })
  command("Buffers", "Telescope buffers", { force = true })
  return mappings
end

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      -- "nvim-telescope/telescope-ui-select.nvim",
    },
    cmd = { "Telescope", "Helptags", "Buffers" },
    keys = {
      { "<C-f>", "<cmd>Telescope find_files<cr>", "n", remap = false },
      { "<C-g>", "<cmd>Telescope live_grep<cr>", "n", remap = false },
      { "<C-b>", "<cmd>Telescope buffers<cr>", "n", remap = false },
    },
    opts = function()
      return {
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
          mappings = telescope_mappings(),
          vimgrep_arguments = {
            "rg",
            "--hidden",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
          },
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
          -- ["ui-select"] = {
          --   require("telescope.themes").get_dropdown {},
          -- },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require "telescope"
      telescope.setup(opts)
      telescope.load_extension "fzf"
      if pcall(require, "notify") then
        telescope.load_extension "notify"
      end
      -- telescope.load_extension "ui-select"
    end,
  },
}
