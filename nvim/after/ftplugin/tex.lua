local autocmd = vim.api.nvim_create_autocmd

vim.opt.textwidth = 80

autocmd("LspAttach", {
  callback = function(args)
    -- Check buffer ft
    local ft = vim.bo[args.buf].filetype
    if vim.list_contains({ "tex", "latex" }, ft) then
      -- Use builtin formatexpr for Markdown and Tex
      vim.bo[args.buf].formatexpr = nil
    end
  end,
})
