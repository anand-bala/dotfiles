local M = {}

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

--- Setup LSP-based diagnostics
---@param opts PluginLspOpts
function M.diagnostics(opts)
  for name, icon in pairs(require("config.icons").diagnostics) do
    name = "DiagnosticSign" .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end
  local inlay_hint = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint

  if opts.inlay_hints.enabled and inlay_hint then
    M.on_attach_hook(function(client, buffer)
      if client.server_capabilities.inlayHintProvider then
        inlay_hint(buffer, true)
      end
    end)
  end

  if
    type(opts.diagnostics.virtual_text) == "table"
    and opts.diagnostics.virtual_text.prefix == "icons"
  then
    opts.diagnostics.virtual_text.prefix = vim.fn.has "nvim-0.10.0" == 0 and "●"
      or function(diagnostic)
        local icons = require("config.icons").diagnostics
        for d, icon in pairs(icons) do
          if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
            return icon
          end
        end
      end
  end

  vim.diagnostic.config(opts.diagnostics)
end

function M.update_capabilities(opts)
  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp_nvim_lsp.default_capabilities() or {},
    opts.capabilities or {}
  )
  return capabilities
end

return M
