local autocmd = vim.api.nvim_create_autocmd

vim.opt_local.tabstop = 2     -- Size of a hard tab (which will be expanded)
vim.opt_local.softtabstop = 2 -- Size of a soft tab
vim.opt_local.shiftwidth = 2  -- Size of indent

autocmd("LspAttach", {
  callback = function(args)
    -- Use builtin formatexpr for Markdown and Tex
    vim.bo[args.buf].formatexpr = nil
  end,
})
