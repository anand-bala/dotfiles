require "astronauta.keymap"

if vim.fn.exists ":TexlabForward" then
  vim.keymap.nnoremap {
    "<leader>lv",
    "<cmd>TexlabForward<CR>",
    silent = false,
    buffer = true,
  }
end

vim.keymap.nmap { "dsc", "<Plug>(vimtex-cmd-delete)", buffer = true }
vim.keymap.nmap { "csc", "<Plug>(vimtex-cmd-change)", buffer = true }
