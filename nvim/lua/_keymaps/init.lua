--- Keybindings for nvim
require('astronauta.keymap')
local cmd = vim.cmd
local nnoremap = vim.keymap.nnoremap
local vnoremap = vim.keymap.vnoremap
local inoremap = vim.keymap.inoremap
local tnoremap = vim.keymap.tnoremap
local nmap = vim.keymap.nmap
local xmap = vim.keymap.xmap

-- First, we set the leader character.
-- Personally, I like backslash
vim.g.mapleader = '\\'

-- shifting visual block should keep it selected
vnoremap {"<", "<gv"}
vnoremap {">", ">gv"}

-- go up/down on visual line
nnoremap {'<Down>', 'gj'}
nnoremap {'<Up>', 'gk'}
vnoremap {'<Down>', 'gj'}
vnoremap {'<Up>', 'gk'}
inoremap {'<Down>', '<C-o>gj'}
inoremap {'<Up>', '<C-o>gk'}

---[[ Searching stuff
nnoremap {
  '<C-f>',
  function() require("telescope.builtin").find_files({follow = true, hidden = true}) end
}
nnoremap {'<C-g>', '<cmd>Telescope live_grep<cr>'}
cmd([[command! Helptags Telescope help_tags]])
cmd([[command! Buffers  Telescope buffers]])
-- ]]

---[[ nvim-lsp
inoremap {'<C-p>', "compe#complete()", silent = true, expr = true}
inoremap {'<CR>', "compe#confirm('<CR>')", silent = true, expr = true}
inoremap {'<C-e>', "compe#close('<C-e>')", silent = true, expr = true}

local lsp_mappings = function(client, bufnr)

  local lspmap = function(opts)
    local lsp_map_opts = {buffer = bufnr, silent = true}
    nnoremap(vim.tbl_extend("keep", opts, lsp_map_opts))
  end
  local te = require("telescope.builtin")

  lspmap {'K', vim.lsp.buf.hover}
  lspmap {'<C-k>', vim.lsp.buf.signature_help}
  lspmap {'gd', te.lsp_definitions}
  lspmap {'gD', vim.lsp.buf.declaration}
  lspmap {'gi', te.lsp_implementations}
  lspmap {'gr', te.lsp_references}
  lspmap {'<leader>D', vim.lsp.buf.type_definition}

  lspmap {'<C-s>', te.lsp_document_symbols}
  lspmap {'<leader><Space>', te.lsp_code_actions}
  lspmap {'<leader>rn', vim.lsp.buf.rename}

  lspmap {'<leader>ld', vim.lsp.diagnostic.show_line_diagnostics}
  lspmap {'[d', vim.lsp.diagnostic.goto_prev}
  lspmap {']d', vim.lsp.diagnostic.goto_next}
  cmd([[command! Diagnostics Telescope lsp_document_diagnostics]])

  if client.resolved_capabilities.document_formatting then
    lspmap {"<leader>f", vim.lsp.buf.formatting}
    cmd([[command! Format <cmd> lua vim.lsp.buf.formatting()]])
  elseif client.resolved_capabilities.document_range_formatting then
    lspmap {"<leader>f", vim.lsp.buf.range_formatting}
    cmd([[command! Format <cmd> lua vim.lsp.buf.range_formatting()]])
  end
end

-- ]]

---[[ Floating Terminal
nnoremap {'<leader>ft', '<cmd>FloatermToggle<CR>', silent = true}
tnoremap {'<leader>ft', '<C-\\><cmd>FloatermToggle<CR>', silent = true}

-- Escape out of terminal mode to normal mode
tnoremap {'<Esc>', '<C-\\><C-n>', silent = true}

-- Launch terminal at bottom of window
nnoremap {'`', '<cmd>FloatermNew --height=0.2 --wintype=split<CR>', silent = true}

-- Create new terminal vsplit
nnoremap {'<C-w>|', '<cmd>FloatermNew --width=0.5 --wintype=vsplit<CR>', silent = true}

-- ]]

---[[ Aligning
nmap {'ga', '<Plug>(EasyAlign)'}
xmap {'ga', '<Plug>(EasyAlign)'}
---]

return {lsp_mappings = lsp_mappings}
