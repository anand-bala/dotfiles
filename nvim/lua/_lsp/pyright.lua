local lspconfig = require('lspconfig')
local setup_lsp = require('_lsp')._setup_lsp
local lspinstall = require("lspinstall")

local M = {}

function M.setup()
    if lspinstall.is_server_installed("python") then
        setup_lsp(lspconfig.python, {})
    else
        setup_lsp(lspconfig.pyright, {})
    end
end

return M
