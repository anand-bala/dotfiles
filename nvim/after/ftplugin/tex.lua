local autocmd = vim.api.nvim_create_autocmd

vim.opt.textwidth = 80

autocmd("LspAttach", {
  callback = function(args)
    -- Use builtin formatexpr for Markdown and Tex
    vim.bo[args.buf].formatexpr = nil
  end,
})
