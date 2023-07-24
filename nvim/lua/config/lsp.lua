local command = vim.api.nvim_create_user_command
local map = vim.keymap.set

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
  lspmap("K", "<cmd>Lspsaga hover_doc<CR>")
  lspmap("<C-k>", vim.lsp.buf.signature_help)
  lspmap("<C-]>", "<cmd>Lspsaga lsp_finder<CR>")
  lspmap("gd", "<cmd>Lspsaga peek_type_definition<CR>")
  lspmap("<C-s>", function()
    local opts = {
      symbols = {
        "interface",
        "class",
        "constructor",
        "method",
        "function",
      },
    }
    if vim.tbl_contains({ "rust", "c", "cpp" }, vim.bo.filetype) then
      vim.list_extend(opts.symbols, { "object", "struct", "enum" })
    end
    require("telescope.builtin").lsp_document_symbols(opts)
  end)
  lspmap("<leader>o", "<cmd>Lspsaga outline<cr>")
  lspmap("<leader><Space>", "<cmd>Lspsaga code_action<CR>", { "n", "v" })
  lspmap("<leader>rn", "<cmd>Lspsaga rename<CR>")

  lspmap("<leader>ld", "<cmd>Lspsaga show_line_diagnostics<CR>")
  lspmap("[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
  lspmap("]d", "<cmd>Lspsaga diagnostic_jump_next<CR>")
  lspmap("[D", function()
    require("lspsaga.diagnostic"):goto_prev { severity = vim.diagnostic.severity.ERROR }
  end)
  lspmap("]D", function()
    require("lspsaga.diagnostic"):goto_next { severity = vim.diagnostic.severity.ERROR }
  end)
  vim.api.nvim_buf_create_user_command(
    bufnr,
    "Diagnostics",
    "Lspsaga show_buf_diagnostics",
    {
      force = true,
    }
  )
  command("WorkspaceDiagnostics", "Telescope diagnostics", {
    force = true,
  })
end

return M
