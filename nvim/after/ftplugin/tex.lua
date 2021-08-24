vim.b.dispatch = "latexmk -pdf -pvc"
vim.cmd [[compiler latexmk]]

vim.g.tex_conceal = "abdgm"
vim.g.tex_flavor = "latex"

vim.opt_local.spellfile = "project.utf-8.add"

require "_keymaps/tex"
