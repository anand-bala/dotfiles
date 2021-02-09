--- Configure the in-built nvim LSP
local lspconfig = require 'lspconfig'

local utils = require '_utils'

-- [[ Diagnostics signs ]]
vim.fn.sign_define("LspDiagnosticsSignError", {
    text = "",
    texthl = "LspDiagnosticsSignError",
    linehl = nil,
    numhl = nil
})

vim.fn.sign_define("LspDiagnosticsSignWarning", {
    text = "⚡",
    texthl = "LspDiagnosticsSignWarning",
    linehl = nil,
    numhl = nil
})

vim.fn.sign_define("LspDiagnosticsSignInformation", {
    text = "✦",
    texthl = "LspDiagnosticsSignInformation",
    linehl = nil,
    numhl = nil
})

vim.fn.sign_define("LspDiagnosticsSignHint", {
    text = "",
    texthl = "LspDiagnosticsSignHint",
    linehl = nil,
    numhl = nil
})

-- [[ Diagnostics handler ]]
vim.lsp.handlers["textDocument/publishDiagnostics"] =
    vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        -- Enable underline, use default values
        underline = true,
        -- This will disable virtual text, like doing:
        -- let g:diagnostic_enable_virtual_text = 0
        virtual_text = false,

        -- This is similar to:
        -- let g:diagnostic_show_sign = 1
        -- To configure sign display,
        --  see: ":help vim.lsp.diagnostic.set_signs()"
        signs = true,

        -- This is similar to:
        -- "let g:diagnostic_insert_delay = 1"
        update_in_insert = false
    })

utils.create_augroup("lspdiagnostics", {
    {'CursorHold', '*', 'lua vim.lsp.diagnostic.show_line_diagnostics()'},
    {'CursorHoldI', '*', 'silent!', 'lua vim.lsp.buf.signature_help()'}
})

local conf = {
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        vim.api.nvim_buf_set_var(bufnr, 'nvim_lsp_buf_active', 1)
        require'_keymaps'.lsp_mappings(bufnr)
    end
}

--- General interface to setup LSP clients
local function setup_lsp(client, config)
    local lsp_config = vim.tbl_extend("keep", config, conf)
    client.setup(lsp_config)
end

setup_lsp(lspconfig.clangd, {
    init_options = {clangdFileStatus = true},
    cmd = {
        "clangd", "--background-index", "--clang-tidy",
        "--header-insertion=iwyu"
    }
})
setup_lsp(lspconfig.pyls, {
    settings = {
        python = {workspaceSymbols = {enabled = true}},
        pyls = {configurationSources = {"flake8"}, pyls_mypy = {enabled = true}}
    }
})
setup_lsp(lspconfig.texlab, require'_lsp/texlab')
setup_lsp(lspconfig.sumneko_lua, require'_lsp/sumneko_lua')
setup_lsp(lspconfig.vimls, {})
setup_lsp(lspconfig.efm, require'_lsp/efm')

-- [[ Additional plugins for LSP ]]
require('lspfuzzy').setup {}
