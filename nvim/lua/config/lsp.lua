--- Mappings for built-in LSP client
local command = vim.api.nvim_create_user_command
local map = vim.keymap.set

local M = {}

M.autoformat = false

function M.on_attach(client, bufnr)
  -- LSP-based formatting
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        if M.autoformat then
          vim.lsp.buf.format({ bufnr = bufnr })
        end
      end,
    })
  end
  -- Setup LSP keymaps
  M.keymaps(client, bufnr)
end

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") > 0

  vim.lsp.buf.format({
    bufnr = buf,
    filter = function(client)
      if have_nls then
        return client.name == "null-ls"
      end
      return client.name ~= "null-ls"
    end,
  })
end

-- Setup LSP-based diagnostics
function M.diagnostics(opts)
  for name, icon in pairs(require("config.icons").diagnostics) do
    name = "DiagnosticSign" .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end
  vim.diagnostic.config(opts.diagnostics)
end

function M.update_capabilities()
  local default_capabilities = vim.lsp.protocol.make_client_capabilities()
  -- Try to use LSP based folding
  default_capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return require("cmp_nvim_lsp").default_capabilities(default_capabilities)
end

function M.keymaps(_, bufnr)
  local lspmap = function(lhs, rhs)
    local lsp_map_opts = { buffer = bufnr, silent = true }
    map("n", lhs, rhs, lsp_map_opts)
  end
  lspmap("K", vim.lsp.buf.hover)
  lspmap("<C-k>", vim.lsp.buf.signature_help)
  lspmap("gd", "<cmd>Telescope lsp_definitions<cr>")
  lspmap("gD", vim.lsp.buf.declaration)
  lspmap("gi", "<cmd>Telescope lsp_implementations<cr>")
  lspmap("gr", "<cmd>Telescope lsp_references<cr>")
  lspmap("<leader>D", vim.lsp.buf.type_definition)

  lspmap("<C-s>", "<cmd>Telescope lsp_document_symbols<cr>")
  lspmap("<leader><Space>", vim.lsp.buf.code_action)
  lspmap("<leader>rn", vim.lsp.buf.rename)

  lspmap("<leader>ld", function()
    vim.diagnostic.open_float(nil, { source = "always" })
  end)
  lspmap("[d", vim.diagnostic.goto_prev)
  lspmap("]d", vim.diagnostic.goto_next)
  vim.api.nvim_buf_create_user_command(0, "Diagnostics", "Telescope diagnostics", {
    force = true,
  })
  command("WorkspaceDiagnostics", "Telescope diagnostics", {
    force = true,
  })

  lspmap("<leader>f", vim.lsp.buf.format)
  command("Format", function()
    vim.lsp.buf.format()
  end, { force = true })
end

return M
