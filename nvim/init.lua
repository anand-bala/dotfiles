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

--- Setup plugins
require("_plugins").setup()
--- Initialize default settings
require("_settings").setup()
--- Initialize global mappings
require("_keymaps").setup()
--- Initialize the built-in LSP
require("_lsp").setup()

--- Register some custom behavior via autocmds
local augroup = require("_utils").create_augroup

-- Spell check on for the following
augroup("spellceck_ft_specific", {
  [[FileType markdown   setlocal spell]],
  [[FileType gitcommit  setlocal spell]],
  [[FileType tex,latex  setlocal spell]],
})

-- Make textwidth smaller for these filetypes
augroup("textwidth_ft_specific", {
  [[FileType gitcommit  setlocal textwidth=79]],
})

-- Custom filetype mappings
augroup("ft_mappings", { [[BufRead,BufNewFile *.tex,*.latex  set filetype=tex]] })

-- Update folds on startup
augroup("update_folds", {
  [[BufEnter * :normal zx]],
})

-- Make the cursor vertically centered
augroup("vertical_center_cursor", {
  [[BufEnter,WinEnter,WinNew,VimResized *,*.* let &scrolloff=winheight(win_getid())/2]],
})

-- Terminal
augroup("terminal_settings", { [[TermOpen * setlocal nonumber norelativenumber]] })
