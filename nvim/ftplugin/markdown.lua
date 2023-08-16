local on_attach_hook = require("config.lsp").on_attach_hook

vim.opt_local.tabstop = 2 -- Size of a hard tab (which will be expanded)
vim.opt_local.softtabstop = 2 -- Size of a soft tab
vim.opt_local.shiftwidth = 2 -- Size of indent

on_attach_hook(function(_, buf)
  -- Use builtin formatexpr for Markdown and Tex
  vim.bo[buf].formatexpr = nil
end, { desc = "Disable formatexpr", group = "DisableLspFormatexpr" })
