local on_attach_hook = require("config.lsp").on_attach_hook
local command = vim.api.nvim_create_user_command
local map = vim.keymap.set

--- Setup autocmds and mappings for LSP-based formatting
--- @param client lsp.Client
--- @param buf integer
local function setup_formatting(client, buf)
  local buf_command = vim.api.nvim_buf_create_user_command
  local ft = vim.bo[buf].filetype

  if client.server_capabilities.documentFormattingProvider then
    local lsp_format = require "config.lsp.format"
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatting", {}),
      buffer = buf,
      callback = function()
        if lsp_format.opts.autoformat then
          lsp_format.format()
        end
      end,
    })

    map("n", "<leader>f", function()
      lsp_format.format { force = true }
    end, {
      desc = "Format the document",
      buffer = buf,
    })
    buf_command(buf, "Format", function()
      local formatters = lsp_format.get_all_formatters(buf)
      vim.ui.select(formatters, {
        prompt = "Select a formatter to use",
        ---@param item lsp.Client
        ---@return string
        format_item = function(item)
          if item.name == "null-ls" then
            local null_ls_fmts =
              require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING")
            return item.name
              .. " ("
              .. table.concat(
                vim.tbl_map(function(f)
                  return "`" .. f.name .. "`"
                end, null_ls_fmts),
                ", "
              )
              .. ")"
          else
            return item.name
          end
        end,
      }, function(choice)
        lsp_format.format_using(choice)
      end)
    end, { desc = "Format the document", force = true })
    buf_command(buf, "FormatToggle", function()
      lsp_format.toggle()
    end, { desc = "Toggle auto-format", force = true })
    buf_command(buf, "ListFormatters", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local formatters = lsp_format.get_formatters(bufnr)
      lsp_format.notify(formatters)
    end, {
      desc = "List the formatters for this buffer",
      force = true,
    })
  end
end

--- Mappings for built-in LSP client
--- @param client lsp.Client
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
  local format = require("config.lsp.format").format
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

on_attach_hook(keymaps)
on_attach_hook(setup_formatting)
