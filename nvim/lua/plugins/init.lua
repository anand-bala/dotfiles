--- Colorscheme
---@type LazyPluginSpec
local colorscheme = {
	'rose-pine/neovim',
  name = 'rose-pine',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000,
  config = function()
    vim.opt.background = "light"
    vim.cmd [[colorscheme rose-pine]]
  end,
}

---@type LazyPluginSpec[]
return {
  colorscheme,
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
    lazy = false,
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
}
