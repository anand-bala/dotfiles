--- Keybindings for nvim
local cmd = vim.cmd
local utils = require '_utils'
local noremap = utils.noremap

-- First, we set the leader character.
-- Personally, I like backslash
vim.g.mapleader = '\\'

-- shifting visual block should keep it selected
noremap('v', '<', '<gv')
noremap('v', '>', '>gv')

-- go up/down on visual line
noremap('n', '<Down>', 'gj')
noremap('n', '<Up>', 'gk')
noremap('v', '<Down>', 'gj')
noremap('v', '<Up>', 'gk')
noremap('i', '<Down>', '<C-o>gj')
noremap('i', '<Up>', '<C-o>gk')

---[[ Searching stuff
-- noremap('n', '<C-f>', '<cmd>Files<CR>')
-- noremap('n', '<C-g>', '<cmd>Rg<CR>')
-- noremap('v', '<C-g>', 'y<cmd>Rg <C-R>"<CR>')
noremap('n', '<C-f>', '<cmd>Telescope find_files<cr>')
noremap('n', '<C-g>', '<cmd>Telescope live_grep<cr>')
cmd([[command! Helptags Telescope help_tags]])
cmd([[command! Buffers  Telescope Buffers]])
-- ]]

---[[ File Manager
vim.g["nnn#set_default_mappings"] = 0
vim.g["nnn#action"] = {
    ["<c-t>"] = "tab split",
    ["<c-x>"] = "split",
    ["<c-v>"] = "vsplit"
}
noremap('n', '<C-n>', '<cmd>NnnPicker %:p:h<CR>', {silent = true})
-- ]]

---[[ nvim-lsp
local compe_options = {silent = true, expr = true}

noremap('i', '<C-p>', "compe#complete()", compe_options)
noremap('i', '<CR>', "compe#confirm('<CR>')", compe_options)
noremap('i', '<C-e>', "compe#close('<C-e>')", compe_options)

local lsp_mappings = function(bufnr)

    local bufmap = vim.api.nvim_buf_set_keymap
    local function lspmap(mode, lhs, rhs, silent)
        if silent == nil then silent = true end
        local lsp_map_options = {silent = (silent == nil and true or silent)}
        bufmap(bufnr, mode, lhs, rhs, lsp_map_options)
    end

    lspmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    lspmap('n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>')
    lspmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>')
    lspmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')

    lspmap('n', '<leader>s', '<cmd>lua vim.lsp.buf.signature_help()<CR>')
    lspmap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>')

    lspmap('n', '<C-s>', '<cmd>Telescope lsp_document_symbol')
    lspmap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')
    lspmap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')

    lspmap('n', '<leader>ld',
           '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')
    lspmap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
    lspmap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')

    cmd [[command! Format         lua vim.lsp.buf.formatting_sync()   ]]
    cmd [[command! Diagnostics    Telescope lsp_document_diagnostics  ]]
    cmd [[command! References     Telescope lsp_references            ]]

    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
    if filetype == "tex" or filetype == "latex" then
        lspmap('n', '<leader>lv', '<cmd>lua TexlabForwardSearch()<CR>')
    end
end

-- ]]

---[[ Floating Terminal
noremap('n', '<A-i>', '<cmd>FloatermNew<CR>', {silent = true})
noremap('t', '<A-i>', '<C-\\><cmd>FloatermNew<CR>', {silent = true})
noremap('n', '<leader>ft', '<cmd>FloatermToggle<CR>', {silent = true})
noremap('t', '<leader>ft', '<C-\\><cmd>FloatermToggle<CR>', {silent = true})

-- Launch terminal at bottom of window
noremap('n', '`', '<cmd>FloatermNew --height=0.2 --wintype=split<CR>',
        {silent = true})

-- Escape out of terminal mode to normal mode
noremap('t', '<Esc>', '<C-\\><C-n>', {silent = true})

-- ]]

return {lsp_mappings = lsp_mappings}
