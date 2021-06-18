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
nnoremap {'<C-f>', '<cmd>Telescope find_files<cr>'}
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

    lspmap {'K', vim.lsp.buf.hover}
    lspmap {'<leader>gd', vim.lsp.buf.definition}
    lspmap {'<leader>gD', vim.lsp.buf.declaration}
    lspmap {'<leader>gi', vim.lsp.buf.implementation}

    lspmap {'<leader>s', vim.lsp.buf.signature_help}
    lspmap {'<leader>D', vim.lsp.buf.type_definition}

    lspmap {'<C-s>', '<cmd>Telescope lsp_document_symbols<CR>'}
    lspmap {'<leader>rn', vim.lsp.buf.rename}

    lspmap {'<leader>ld', vim.lsp.diagnostic.show_line_diagnostics}
    lspmap {'[d', vim.lsp.diagnostic.goto_prev}
    lspmap {']d', vim.lsp.diagnostic.goto_next}

    if client.resolved_capabilities.document_formatting then
        lspmap {"<leader>f", vim.lsp.buf.formatting}
    elseif client.resolved_capabilities.document_range_formatting then
        lspmap {"<leader>f", vim.lsp.buf.range_formatting}
    end
end

-- ]]

---[[ Floating Terminal
nnoremap {'<leader>ft', '<cmd>FloatermToggle<CR>', silent = true}
tnoremap {'<leader>ft', '<C-\\><cmd>FloatermToggle<CR>', silent = true}

-- Escape out of terminal mode to normal mode
tnoremap {'<Esc>', '<C-\\><C-n>', silent = true}

-- Launch terminal at bottom of window
nnoremap {
    '`',
    '<cmd>FloatermNew --height=0.2 --wintype=split<CR>',
    silent = true
}

-- Create new terminal vsplit
nnoremap {
    '<C-w>|',
    '<cmd>FloatermNew --width=0.5 --wintype=vsplit<CR>',
    silent = true
}

-- ]]

---[[ Aligning
nmap {'ga', '<Plug>(EasyAlign)'}
xmap {'ga', '<Plug>(EasyAlign)'}
---]

return {lsp_mappings = lsp_mappings}
