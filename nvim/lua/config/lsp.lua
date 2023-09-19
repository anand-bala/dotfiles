local command = vim.api.nvim_create_user_command
local map = vim.keymap.set

local M = {}

--- Wrapper to add `on_attach` hooks for LSP
---@param on_attach fun(client:lsp.Client, buffer:integer)
---@param opts? {desc?:string,once?:boolean,group?:integer|string}
function M.on_attach_hook(on_attach, opts)
  opts = opts or {}
  if opts["group"] ~= nil and type(opts.group) == "string" then
    opts.group = vim.api.nvim_create_augroup(opts.group --[[@as string]], {})
  end
  vim.api.nvim_create_autocmd(
    "LspAttach",
    vim.tbl_extend("force", opts, {
      callback = function(args)
        local buffer = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client ~= nil then
          on_attach(client, buffer)
        end
      end,
    })
  )
end

--- Setup LSP-based diagnostics
---@param opts PluginLspOpts
function M.diagnostics(opts)
  for name, icon in pairs(require("config.icons").diagnostics) do
    name = "DiagnosticSign" .. name
    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end

  if opts.inlay_hints.enabled then
    M.on_attach_hook(function(client, buffer)
      if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint(buffer, true)
      end
    end, { desc = "LSP: Enable inlay hints" })
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

--- Mappings for built-in LSP client
--- @param _ lsp.Client
--- @param bufnr integer
function M.keymaps(_, bufnr)
  ---@param lhs string
  ---@param rhs string|function
  ---@param modes string|table|nil
  local lspmap = function(lhs, rhs, modes)
    modes = modes or { "n" }
    local lsp_map_opts = { buffer = bufnr, silent = true }
    map(modes, lhs, rhs, lsp_map_opts)
  end
  local telescope = require "telescope.builtin"

  lspmap("K", vim.lsp.buf.hover)
  lspmap("<C-k>", vim.lsp.buf.signature_help)
  lspmap("<C-]>", function()
    telescope.lsp_references {
      show_line = false,
      fname_width = 50,
    }
  end)
  lspmap("gd", telescope.lsp_definitions)
  lspmap("<C-s>", require("telescope.builtin").lsp_document_symbols)
  lspmap("<leader><Space>", vim.lsp.buf.code_action, { "n", "v" })
  lspmap("<leader>rn", vim.lsp.buf.rename, { "n" })
  lspmap("<leader>ld", function()
    vim.diagnostic.open_float {
      bufnr = bufnr,
      scope = "line",
    }
  end)
  lspmap("[d", function()
    vim.diagnostic.goto_prev { float = true }
  end)
  lspmap("]d", function()
    vim.diagnostic.goto_next { float = true }
  end)
  lspmap("[D", function()
    vim.diagnostic.goto_prev { float = true, severity = vim.diagnostic.severity.ERROR }
  end)
  lspmap("]D", function()
    vim.diagnostic.goto_next { float = true, severity = vim.diagnostic.severity.ERROR }
  end)
end

return M
