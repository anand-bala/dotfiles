vim.b.dispatch = 'latexmk -pdf -pvc'
vim.cmd [[compiler latexmk]]

-- vim.opt_local.formatoptions:append({t = true})
vim.opt_local.textwidth = 88

vim.g.tex_conceal = "abdgm"
vim.g.tex_flavor = 'latex'

-- Some custom keybindings
if vim.fn.exists(":TexlabForward") then
    local bufmap = vim.api.nvim_buf_set_keymap
    local function lspmap(mode, lhs, rhs, silent)
        if silent == nil then silent = true end
        local lsp_map_options = {silent = (silent == nil and true or silent)}
        bufmap(bufnr, mode, lhs, rhs, lsp_map_options)
    end

    vim.keymap.nnoremap("<leader>lv", "<cmd>TexlabForward<CR>",
                        {silent = false, buffer = true})

    lspmap('n', '<leader>lv', '<cmd>TexlabForward<CR>')
end
