local nvim_lsp = require 'nvim_lsp'
local api = vim.api
local cmd = vim.api.nvim_command
local tbl_extend = vim.tbl_extend
local buf_map = vim.api.nvim_buf_set_keymap

local lsp_status = require('lsp-status')

lsp_status.register_progress()

local conf = {}

-- Configure LSP client when it attaches to buffer
function conf.on_attach(client, bufnr)
    require'diagnostic'.on_attach()
    require'completion'.on_attach()
    lsp_status.on_attach(client)

    api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    api.nvim_buf_set_var(bufnr, 'nvim_lsp_buf_active', 1)

    -- cmd [[autocmd CursorHold  <buffer> lua vim.lsp.util.show_line_diagnostics()]]
    -- cmd [[autocmd CursorHoldI <buffer> lua vim.lsp.util.show_line_diagnostics()]]

    local mapping_opts = {}
    mapping_opts['silent'] = true
    mapping_opts['noremap'] = true

    local function lsp_nmap(capability, lhs, rhs)
        if capability then
            buf_map(bufnr, 'n', lhs, rhs, mapping_opts)
        end
    end
    local rcaps = client.resolved_capabilities

    lsp_nmap(rcaps.document_formatting, '<Plug>(nvim-lsp-formatting)', '<cmd>lua vim.lsp.buf.formatting()<CR>')

    lsp_nmap(rcaps.hover, '<Plug>(nvim-lsp-hover)', '<cmd>lua vim.lsp.buf.hover()<CR>')

    lsp_nmap(rcaps.implementation, '<Plug>(nvim-lsp-implementation)', '<cmd>lua vim.lsp.buf.implementation()<CR>')
end

local function setup_lsp(client, config)
    local lsp_config = tbl_extend("keep", config, conf)
    lsp_config.capabilities = tbl_extend('keep', lsp_config.capabilities or {}, lsp_status.capabilities)
    client.setup(lsp_config)
end

local function setup()
    -- setup_lsp(nvim_lsp.ccls, {})
    setup_lsp(nvim_lsp.clangd, {
      callbacks = lsp_status.extensions.clangd.setup(),
      init_options = {
        clangdFileStatus = true
      }
    })
    setup_lsp(nvim_lsp.pyls_ms, {
      callbacks = lsp_status.extensions.pyls_ms.setup(),
      settings = { python = { workspaceSymbols = { enabled = true }}},
    })
    setup_lsp(nvim_lsp.julials, {})

    setup_lsp(nvim_lsp.texlab, require'lsp-texlab'.config())

    setup_lsp(nvim_lsp.sumneko_lua, {})
    setup_lsp(nvim_lsp.vimls, {})
end

return {
    setup = setup
}

