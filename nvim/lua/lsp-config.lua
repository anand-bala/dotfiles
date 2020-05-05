-- Configure LSP client when it attaches to buffer
local function on_attach_callback(client, bufnr)
    require'diagnostic'.on_attach()
    require'completion'.on_attach()
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.api.nvim_buf_set_var(bufnr, 'nvim_lsp_buf_active', 1)

    vim.api.nvim_command [[autocmd CursorHold  <buffer> lua require'diagnostic.util'.show_line_diagnostics()]]
    vim.api.nvim_command [[autocmd CursorHoldI <buffer> lua require'diagnostic.util'.show_line_diagnostics()]]
end

local function setup()
    local nvim_lsp = require 'nvim_lsp'

    nvim_lsp.clangd.setup{on_attach = on_attach_callback}
    nvim_lsp.pyls_ms.setup{on_attach = on_attach_callback}
    nvim_lsp.rust_analyzer.setup{on_attach = on_attach_callback}
    nvim_lsp.texlab.setup{on_attach = on_attach_callback}
    nvim_lsp.sumneko_lua.setup{
        on_attach= on_attach_callback;
        settings = {
            Lua = {
                completion = {
                    keywordSnippet = "Disable";
                };
                runtime = {
                    version = "LuaJIT";
                };
            };
        };
    }
    nvim_lsp.vimls.setup{on_attach=on_attach_callback}
end

return {
    setup = setup
}

