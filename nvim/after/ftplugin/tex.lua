vim.g.tex_conceal = "abdgm"
vim.g.tex_flavor = "latex"

if vim.fn.exists ":TexlabForward" then
  vim.keymap.set("n", "<leader>lv", "<cmd>TexlabForward<CR>", {
    silent = false,
    buffer = true,
    remap = false,
  })
end

if vim.fn.exists ":TexlabBuild" then
  vim.keymap.set("n", "<leader>ll", "<cmd>TexlabBuild<CR>", {
    silent = false,
    buffer = true,
    remap = false,
  })
end

local cmp = require "cmp"
cmp.setup.buffer {
  sources = {
    { name = "omni" },
    { name = "luasnip" },
    { name = "buffer" },
    -- { name = "nvim_lsp" },
    { name = "treesitter" },
    { name = "spell" },
  },
}

if vim.fn.exists ":VimtexTocToggle" then
  vim.keymap.set("n", "<C-t>", "<cmd>VimtexTocToggle<CR>", {
    buffer = true,
  })
end
