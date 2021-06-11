local lspconfig = require('lspconfig')
local lspinstall = require("lspinstall")
local setup_lsp = require('_lsp')._setup_lsp

local M = {}

local conf = {}

function M.setup()
    if lspinstall.is_server_installed("vim") then
        setup_lsp(lspconfig.vim, conf)
    end
end

return M
