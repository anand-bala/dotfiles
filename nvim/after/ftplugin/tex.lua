vim.b.dispatch = "latexmk -pdf -pvc"
vim.cmd [[compiler latexmk]]

vim.g.tex_conceal = "abdgm"
vim.g.tex_flavor = "latex"

vim.opt_local.spellfile = "project.utf-8.add"

if vim.fn.exists ":TexlabForward" then
  vim.keymap.nnoremap {
    "<leader>lv",
    "<cmd>TexlabForward<CR>",
    silent = true,
    buffer = true,
  }
end
