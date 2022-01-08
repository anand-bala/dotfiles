--- Keybindings for nvim
local cmd = vim.cmd
local map = vim.keymap.set

-- First, we set the leader character.
-- Personally, I like backslash
vim.g.mapleader = "\\"

-- Disable 'hjkl' for movements
map("", "h", "<nop>", { remap = false })
map("", "j", "<nop>", { remap = false })
map("", "k", "<nop>", { remap = false })
map("", "l", "<nop>", { remap = false })

-- shifting visual block should keep it selected
map("v", "<", "<gv", { remap = false })
map("v", ">", ">gv", { remap = false })

-- go up/down on visual line
map("n", "<Down>", "gj", { remap = false })
map("n", "<Up>", "gk", { remap = false })
map("v", "<Down>", "gj", { remap = false })
map("v", "<Up>", "gk", { remap = false })
map("i", "<Down>", "<C-o>gj", { remap = false })
map("i", "<Up>", "<C-o>gk", { remap = false })

-- Yank entire line on Y
map("n", "Y", "yy", { remap = false })

---[[ Searching stuff
map("n", "<C-f>", function()
  require("telescope.builtin").find_files { follow = true, hidden = true }
end, { remap = false })

map("n", "<C-g>", "<cmd>Telescope live_grep<cr>", { remap = false })
map("n", "<C-b>", "<cmd>Telescope buffers<cr>", { remap = false })
cmd [[command! Helptags Telescope help_tags]]
cmd [[command! Buffers  Telescope buffers]]
-- ]]

---[[ Terminal
-- Escape out of terminal mode to normal mode
map("t", "<Esc>", "<C-\\><C-n>", { silent = true, remap = false })

-- Launch terminal at bottom of window
map("n", "`", "<cmd>Term<CR>", { silent = true, remap = false })
-- Create new terminal vsplit
map("n", "<C-w>|", "<cmd>VTerm<CR>", { silent = true, remap = false })
-- ]]

local tabline = require "tabline"
map("n", "bt", tabline.buffer_next, { silent = true, remap = false })
map("n", "bT", tabline.buffer_previous, { silent = true, remap = false })

---[[ Aligning
map({ "n", "x" }, "ga", "<Plug>(EasyAlign)")
---]
