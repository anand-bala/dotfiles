vim.b.dispatch = 'latexmk -pdf -pvc'
vim.cmd [[compiler latexmk]]

-- vim.opt_local.formatoptions:append({t = true})
vim.opt_local.textwidth = 88

vim.g.tex_conceal = "abdgm"
vim.g.tex_flavor = 'latex'
