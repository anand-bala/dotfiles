local settings = require "_settings"
settings.defaults()

---[[ Plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("_plugins", {
  defaults = { lazy = true },
  install = { colorscheme = { "solarized" } },
  checker = { enabled = true, notify = false },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = false, -- get a notification when changes are found
  },
  performance = {
    cache = {
      enabled = true,
      -- disable_events = {},
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
---]]
settings.post_plugin()

-- Register some custom behavior via autocmds

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Custom filetype mappings
do
  local ft_mappings = augroup("ft_mappings", {})
  autocmd({ "BufRead", "BufNewFile" }, {
    group = ft_mappings,
    pattern = { "*.tex", "*.latex" },
    callback = function()
      vim.opt.filetype = "tex"
    end,
  })
end

-- Custom spellfile for filetypes
do
  local function set_spellfile()
    vim.opt_local.spell = true
    vim.opt_local.spellfile = "project.utf-8.add"
  end

  local ft_spellfile = augroup("ft_spellfile", {})
  autocmd({ "FileType" }, {
    group = ft_spellfile,
    pattern = "markdown,tex",
    callback = set_spellfile,
  })
end

-- Terminal
autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})
