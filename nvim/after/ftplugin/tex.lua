vim.g.tex_conceal = "abdgm"
vim.g.tex_flavor = "latex"

vim.opt_local.spellfile = "project.utf-8.add"

if vim.fn.exists ":TexlabForward" then
  vim.keymap.nnoremap {
    "<leader>lv",
    "<cmd>TexlabForward<CR>",
    silent = false,
    buffer = true,
  }
end

if vim.fn.exists ":TexlabBuild" then
  vim.keymap.nnoremap {
    "<leader>ll",
    "<cmd>TexlabBuild<CR>",
    silent = false,
    buffer = true,
  }
end
