require "astronauta.keymap"

local cmd = vim.cmd
local nnoremap = vim.keymap.nnoremap

local M = {}

function M.setup(client, bufnr)
  local lspmap = function(opts)
    local lsp_map_opts = { buffer = bufnr, silent = true }
    nnoremap(vim.tbl_extend("keep", opts, lsp_map_opts))
  end
  local te = require "telescope.builtin"

  lspmap { "K", vim.lsp.buf.hover }
  lspmap { "<C-k>", vim.lsp.buf.signature_help }
  lspmap { "gd", te.lsp_definitions }
  lspmap { "gD", vim.lsp.buf.declaration }
  lspmap { "gi", te.lsp_implementations }
  lspmap { "gr", te.lsp_references }
  lspmap { "<leader>D", vim.lsp.buf.type_definition }

  lspmap { "<C-s>", te.lsp_document_symbols }
  lspmap { "<leader><Space>", te.lsp_code_actions }
  lspmap { "<leader>rn", vim.lsp.buf.rename }

  lspmap { "<leader>ld", vim.lsp.diagnostic.show_line_diagnostics }
  lspmap { "[d", vim.lsp.diagnostic.goto_prev }
  lspmap { "]d", vim.lsp.diagnostic.goto_next }
  cmd [[command! Diagnostics Telescope lsp_document_diagnostics]]

  if client.resolved_capabilities.document_formatting then
    lspmap { "<leader>f", vim.lsp.buf.formatting }
    cmd [[command! Format lua vim.lsp.buf.formatting()]]
  elseif client.resolved_capabilities.document_range_formatting then
    lspmap { "<leader>f", vim.lsp.buf.range_formatting }
    cmd [[command! Format lua vim.lsp.buf.range_formatting()]]
  end
end

return M
