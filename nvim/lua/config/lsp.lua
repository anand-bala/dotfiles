local command = vim.api.nvim_create_user_command
local map = vim.keymap.set

local M = {}

M.autoformat = false

--- Wrapper to add `on_attach` hooks for LSP
---@param on_attach fun(client, buffer)
function M.on_attach_hook(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local buffer = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, buffer)
    end,
  })
end

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  local have_nls = #require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING")
    > 0

  vim.lsp.buf.format {
    bufnr = buf,
    filter = function(client)
      if have_nls then
        return client.name == "null-ls"
      end
      return client.name ~= "null-ls"
    end,
  }
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

return M
