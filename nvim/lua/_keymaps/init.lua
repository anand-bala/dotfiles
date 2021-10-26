require "astronauta.keymap"

--- Keybindings for nvim
local cmd = vim.cmd
local nnoremap = vim.keymap.nnoremap
local vnoremap = vim.keymap.vnoremap
local inoremap = vim.keymap.inoremap
local tnoremap = vim.keymap.tnoremap
local nmap = vim.keymap.nmap
local xmap = vim.keymap.xmap
local noremap = vim.keymap.noremap

-- First, we set the leader character.
-- Personally, I like backslash
vim.g.mapleader = "\\"

-- Disable 'hjkl' for movements
noremap { "h", "<nop>" }
noremap { "j", "<nop>" }
noremap { "k", "<nop>" }
noremap { "l", "<nop>" }

-- shifting visual block should keep it selected
vnoremap { "<", "<gv" }
vnoremap { ">", ">gv" }

-- go up/down on visual line
nnoremap { "<Down>", "gj" }
nnoremap { "<Up>", "gk" }
vnoremap { "<Down>", "gj" }
vnoremap { "<Up>", "gk" }
inoremap { "<Down>", "<C-o>gj" }
inoremap { "<Up>", "<C-o>gk" }

---[[ Searching stuff
nnoremap {
  "<C-f>",
  function()
    require("telescope.builtin").find_files { follow = true, hidden = true }
  end,
}
nnoremap { "<C-g>", "<cmd>Telescope live_grep<cr>" }
nnoremap { "<C-b>", "<cmd>Telescope buffers<cr>" }
cmd [[command! Helptags Telescope help_tags]]
cmd [[command! Buffers  Telescope buffers]]
-- ]]

---[[ Floating Terminal
nnoremap { "<leader>ft", "<cmd>FloatermToggle<CR>", silent = true }
tnoremap { "<leader>ft", "<C-\\><cmd>FloatermToggle<CR>", silent = true }

-- Escape out of terminal mode to normal mode
tnoremap { "<Esc>", "<C-\\><C-n>", silent = true }

-- Launch terminal at bottom of window
nnoremap { "`", "<cmd>FloatermNew --height=0.2 --wintype=split<CR>", silent = true }

-- Create new terminal vsplit
nnoremap {
  "<C-w>|",
  "<cmd>FloatermNew --width=0.5 --wintype=vsplit<CR>",
  silent = true,
}
-- ]]

local tabline = require "tabline"
nnoremap { "bt", tabline.buffer_next, silent = true }
nnoremap { "bT", tabline.buffer_previous, silent = true }

---[[ Aligning
nmap { "ga", "<Plug>(EasyAlign)" }
xmap { "ga", "<Plug>(EasyAlign)" }
---]
