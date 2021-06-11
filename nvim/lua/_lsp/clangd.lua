local lspconfig = require('lspconfig')
local setup_lsp = require('_lsp')._setup_lsp

local M = {}

function M.setup()
    setup_lsp(lspconfig.clangd, {
        init_options = {clangdFileStatus = true},
        cmd = {
            "clangd", "--background-index", "--clang-tidy",
            "--header-insertion=iwyu"
        }
    })
end

return M
