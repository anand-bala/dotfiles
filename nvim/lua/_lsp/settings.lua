local M = {}
--- Diagnostics signs
function M.setup_diagnostic_signs()
  vim.fn.sign_define(
    "LspDiagnosticsSignError",
    { text = "", texthl = "LspDiagnosticsSignError", linehl = nil, numhl = nil }
  )

  vim.fn.sign_define(
    "LspDiagnosticsSignWarning",
    { text = "⚡", texthl = "LspDiagnosticsSignWarning", linehl = nil, numhl = nil }
  )

  vim.fn.sign_define("LspDiagnosticsSignInformation", {
    text = "✦",
    texthl = "LspDiagnosticsSignInformation",
    linehl = nil,
    numhl = nil,
  })

  vim.fn.sign_define(
    "LspDiagnosticsSignHint",
    { text = "", texthl = "LspDiagnosticsSignHint", linehl = nil, numhl = nil }
  )
end

--- Diagnostics handler
function M.setup_custom_handlers()
  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics,
    {
      -- Enable underline, use default values
      underline = true,
      -- This will disable virtual text, like doing:
      -- let g:diagnostic_enable_virtual_text = 0
      virtual_text = false,

      -- This is similar to:
      -- let g:diagnostic_show_sign = 1
      -- To configure sign display,
      --  see: ":help vim.lsp.diagnostic.set_signs()"
      signs = true,

      -- This is similar to:
      -- "let g:diagnostic_insert_delay = 1"
      update_in_insert = false,
    }
  )

  -- [[ Formatting handler ]]
  vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then
      return
    end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
      local view = vim.fn.winsaveview()
      vim.lsp.util.apply_text_edits(result, bufnr)
      vim.fn.winrestview(view)
      if bufnr == vim.api.nvim_get_current_buf() then
        vim.api.nvim_command "noautocmd :update"
      end
    end
  end
end

function M.on_attach(client, bufnr)
  local utils = require "_utils"
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  if
    client.resolved_capabilities.document_formatting
    or client.resolved_capabilities.document_range_formatting
  then
    utils.create_buffer_augroup("lspformat", {
      [[BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync(nil, 1000)]], -- Run all formatters at 1000ms timeout
    })
  end
  require("_keymaps/lsp").setup(client, bufnr)

  utils.create_buffer_augroup(
    "lspbehavior",
    { [[CursorHold  <buffer>  lua vim.lsp.diagnostic.show_line_diagnostics()]] }
  )
end

function M.ensure_installed()
  local lsp_installer = require "nvim-lsp-installer"
  local ensure_installed_servers = { "vimls", "sumneko_lua" }
  for _, name in ipairs(ensure_installed_servers) do
    local ok, server = lsp_installer.get_server(name)
    -- Check that the server is supported in nvim-lsp-installer
    if ok and not server:is_installed() then
      print("Installing " .. name)
      server:install()
    end
  end
end

return M
