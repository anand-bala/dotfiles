local lspconfig = require('lspconfig')
local setup_lsp = require('_lsp')._setup_lsp

local M = {}

function M.setup() setup_lsp(lspconfig.zls, {}) end

return M
