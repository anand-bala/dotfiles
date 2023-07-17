local on_attach_hook = require("config.lsp").on_attach_hook

vim.opt_local.textwidth = 80
vim.opt_local.formatoptions:append "]"

vim.opt_local.formatlistpat = [[^\s*\(\d\+[\]:.)}\t ]\)\|\(\\item \)\s*]]

on_attach_hook(function(args)
  -- Check buffer ft
  local ft = vim.bo[args.buf].filetype
  if vim.list_contains({ "tex", "latex" }, ft) then
    -- Use builtin formatexpr for Markdown and Tex
    vim.bo[args.buf].formatexpr = nil
    -- Setup Texlab keymaps
    vim.keymap.set("n", "<leader>lv", "<cmd>TexlabForward<CR>", {
      silent = false,
      buffer = args.buf,
      remap = false,
    })

    vim.keymap.set("n", "<leader>ll", "<cmd>TexlabBuild<CR>", {
      silent = false,
      buffer = args.buf,
      remap = false,
    })
  end
end)
