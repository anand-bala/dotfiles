--- Configure the in-built nvim LSP
local lspconfig = require 'lspconfig'

local utils = require '_utils'

local M = {}

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

-- [[ Formatting handler ]]
-- vim.lsp.handlers["textDocument/formatting"] =
--     function(err, _, result, _, bufnr)
--         if err ~= nil or result == nil then return end
--         if not vim.api.nvim_buf_get_option(bufnr, "modified") then
--             local view = vim.fn.winsaveview()
--             vim.lsp.util.apply_text_edits(result, bufnr)
--             vim.fn.winrestview(view)
--             if bufnr == vim.api.nvim_get_current_buf() then
--                 vim.api.nvim_command("noautocmd :update")
--             end
--         end
--     end

-- [[ Snippets ]]
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local conf = {
    on_init = function(client)
        client.config.flags = {}
        if client.config.flags then
            client.config.flags.allow_incremental_sync = true
        end
    end,
    on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        if client.resolved_capabilities.document_formatting then
            utils.create_buffer_augroup("LspFormat", {
                [[BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
            })
        end
        require'_keymaps'.lsp_mappings(bufnr)

        utils.create_buffer_augroup("lspbehavior", {
            [[CursorHold  <buffer>  lua vim.lsp.diagnostic.show_line_diagnostics()]],
            [[CursorHoldI <buffer>  lua vim.lsp.buf.signature_help()]]
        })
    end,
    capabilities = capabilities
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
---[[ Python
setup_lsp(lspconfig.pyright, {})
setup_lsp(lspconfig.jedi_language_server, {})
---]]
setup_lsp(lspconfig.texlab, require '_lsp/texlab')
setup_lsp(lspconfig.sumneko_lua, require '_lsp/sumneko_lua')
setup_lsp(lspconfig.vimls, {})
setup_lsp(lspconfig.efm, require '_lsp/efm')

return M
