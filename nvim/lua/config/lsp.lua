--- Mappings for built-in LSP client
local command = vim.api.nvim_create_user_command
local map = vim.keymap.set

local M = {}

M.autoformat = false

--- Default on attach hook for LSPs
--- @param client vim.lsp.client
--- @param bufnr integer
function M.on_attach(client, bufnr)
  -- LSP-based formatting
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
  ---@diagnostic disable-next-line: undefined-field
  if client.supports_method "textDocument/formatting" then
    vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        if M.autoformat then
          vim.lsp.buf.format { bufnr = bufnr }
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

function M.keymaps(client, bufnr)
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

  if client.supports_method "textDocument/formatting" then
    local format = function(opts)
      opts = opts or {}
      opts = vim.tbl_deep_extend("force", { async = true }, opts)
      vim.lsp.buf.format(opts)
    end
    lspmap("<leader>f", format)
    command("Format", format, { force = true })
  end

  local ft = vim.bo[bufnr].filetype
  if vim.tbl_contains({ "tex" }, ft) then
    vim.keymap.set("n", "<leader>lv", "<cmd>TexlabForward<CR>", {
      silent = false,
      buffer = false,
      remap = false,
    })

    vim.keymap.set("n", "<leader>ll", "<cmd>TexlabBuild<CR>", {
      silent = false,
      buffer = false,
      remap = false,
    })
  end
end

return M
