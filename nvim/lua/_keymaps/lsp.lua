local cmd = vim.cmd
local map = vim.keymap.set

local M = {}

function M.setup(client, bufnr)
  local lspmap = function(lhs, rhs)
    local lsp_map_opts = { buffer = bufnr, silent = true }
    map("n", lhs, rhs, lsp_map_opts)
  end
  local te = require "telescope.builtin"

  lspmap("K", vim.lsp.buf.hover)
  lspmap("<C-k>", vim.lsp.buf.signature_help)
  lspmap("gd", te.lsp_definitions)
  lspmap("gD", vim.lsp.buf.declaration)
  lspmap("gi", te.lsp_implementations)
  lspmap("gr", te.lsp_references)
  lspmap("<leader>D", vim.lsp.buf.type_definition)

  lspmap("<C-s>", te.lsp_document_symbols)
  lspmap("<leader><Space>", te.lsp_code_actions)
  lspmap("<leader>rn", vim.lsp.buf.rename)

  lspmap("<leader>ld", function()
    vim.diagnostic.open_float(nil, { source = "always" })
  end)
  lspmap("[d", vim.diagnostic.goto_prev)
  lspmap("]d", vim.diagnostic.goto_next)
  cmd [[command! Diagnostics Telescope diagnostics bufnr=0]]
  cmd [[command! WorkspaceDiagnostics Telescope diagnostics]]

  if client.resolved_capabilities.document_formatting then
    lspmap("<leader>f", vim.lsp.buf.formatting_seq_sync)
    cmd [[command! Format lua vim.lsp.buf.formatting_seq_sync()]]
  elseif client.resolved_capabilities.document_range_formatting then
    lspmap("<leader>f", vim.lsp.buf.range_formatting)
    cmd [[command! Format lua vim.lsp.buf.range_formatting()]]
  end
end

return M
