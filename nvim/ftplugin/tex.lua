local on_attach_hook = require("config.lsp").on_attach_hook

vim.g.tex_conceal = "abdgm"
vim.g.tex_flavor = "latex"
vim.g.texlab_builder = "latexmk"
if
  vim.fn.has "win32" == 1
  or vim.fn.has "wsl" == 1
  or (vim.fn.has "unix" == 1 and os.getenv "WSLENV" ~= nil)
then
  if vim.fn.executable "SumatraPDF.exe" then
    vim.g.texlab_forward_search = "sumatrapdf"
  end
elseif vim.fn.has "unix" == 1 then
  if vim.fn.executable "zathura" then
    vim.g.texlab_forward_search = "zathura"
  end
end

vim.opt_local.textwidth = 80
vim.opt_local.formatoptions = vim.opt_local.formatoptions + "]"
vim.opt_local.formatlistpat = [[^\s*\(\d\+[\]:.)}\t ]\)\|\(\\item \)\s*]]

on_attach_hook(function(client, buffer)
  if client.name ~= "texlab" then
    return
  end

  -- Use builtin formatexpr for Markdown and Tex
  vim.bo[buffer].formatexpr = nil

  -- Setup Texlab keymaps
  vim.keymap.set("n", "<leader>lv", "<cmd>TexlabForward<CR>", {
    silent = false,
    buffer = buffer,
    remap = false,
  })
  vim.keymap.set("n", "<leader>ll", "<cmd>TexlabBuild<CR>", {
    silent = false,
    buffer = buffer,
    remap = false,
  })
end, {
  desc = "Setup Texlab configurations, keymaps, and other options",
  once = true,
  group = "LspTexlabSettings",
})
