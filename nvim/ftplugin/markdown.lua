vim.opt_local.tabstop = 2 -- Size of a hard tab (which will be expanded)
vim.opt_local.softtabstop = 2 -- Size of a soft tab
vim.opt_local.shiftwidth = 2 -- Size of indent

vim.opt_local.formatoptions = vim.opt_local.formatoptions + "]"
vim.opt_local.formatlistpat = [[^\s*\(\d\+[\]:.)}\t ]\)\|\(\\item \)\s*]]

-- Use builtin formatexpr for Markdown and Tex
vim.opt_local.formatexpr = nil
