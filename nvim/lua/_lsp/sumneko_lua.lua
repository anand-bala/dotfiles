local lspconfig = require('lspconfig')
local configs = require('lspconfig/configs')
local lspinstall = require("lspinstall")
local setup_lsp = require('_lsp')._setup_lsp

local M = {}

local conf = {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = vim.split(package.path, ';')
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim', 'vimp'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true
                }
            }
        }
    }
}

function M.setup()
    if lspinstall.is_server_installed("lua") then
        setup_lsp(lspconfig.lua, conf)
    end
end

return M
