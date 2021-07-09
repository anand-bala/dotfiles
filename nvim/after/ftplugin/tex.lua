vim.b.dispatch = 'latexmk -pdf -pvc'
vim.cmd [[compiler latexmk]]

-- vim.opt_local.formatoptions:append({t = true})
vim.opt_local.textwidth = 88

vim.g.tex_conceal = "abdgm"
vim.g.tex_flavor = 'latex'

-- Some custom keybindings
if vim.fn.exists(":TexlabForward") then
    vim.keymap.nnoremap({
        "<leader>lv",
        "<cmd>TexlabForward<CR>",
        silent = false,
        buffer = true
    })
end
