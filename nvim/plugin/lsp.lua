local on_attach_hook = require("config.lsp").on_attach_hook
local command = vim.api.nvim_create_user_command
local map = vim.keymap.set

--- LSP-based formatting
--- @param client vim.lsp.client
--- @param bufnr integer
local function lsp_formatting(client, bufnr)
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
  ---@diagnostic disable-next-line: undefined-field
  if client.server_capabilities.documentFormattingProvider then
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
end

--- Mappings for built-in LSP client
--- @param client vim.lsp.client
--- @param bufnr integer
local function keymaps(client, bufnr)
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

  if client.server_capabilities.documentFormattingProvider then
    lspmap("<leader>f", "<cmd>Format<CR>")
    -- command("Format", format, { force = true })
  end
end

-- on_attach_hook(lsp_formatting)
on_attach_hook(keymaps)

on_attach_hook(function(client, buf)
  require("lsp-format").on_attach(client)
end)
