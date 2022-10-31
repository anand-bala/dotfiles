-- Disable some built-in plugins we don't want
local disabled_built_ins = {
  "netrwPlugin",
}

for _, disabled_plugin in ipairs(disabled_built_ins) do
  vim.g["loaded_" .. disabled_plugin] = 1
end

-- Fishshell fixes
if string.match(vim.o.shell, "fish$") then
  vim.g.terminal_shell = "fish"
  vim.opt.shell = "sh"
end

vim.cmd "syntax enable"

-- Setup plugins
require("_plugins").setup()
-- Initialize default settings
require("_settings").setup()
-- Initialize global mappings
require("_keymaps").setup()

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

-- Update folds on startup
do
  local update_folds = augroup("update_folds", {})
  autocmd("BufEnter", {
    group = update_folds,
    pattern = "*",
    command = ":normal zx",
  })
end

-- BUG: Looks like Neovim doesn't run a lot of things on VimEnter with a file arg. Fix that
do
  local edit_arg_file = augroup("edit_arg_file", {})
  autocmd("VimEnter", {
    group = edit_arg_file,
    pattern = "*",
    callback = function()
      for _, buf in ipairs(vim.fn.argv()) do
        vim.cmd((":e %s"):format(buf))
      end
    end,
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
