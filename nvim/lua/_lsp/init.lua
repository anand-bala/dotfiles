-- Register custom servers
require("_lsp/lemminx").register_custom()
require("_lsp/zig").register_custom()
require("_lsp/grammar-guard").register_custom()
--- Load lspinstall
local lspinstall = require "lspinstall"
lspinstall.setup()

local M = {}

--- Diagnostics signs
local function setup_diagnostic_signs()
  vim.fn.sign_define(
    "LspDiagnosticsSignError",
    { text = "", texthl = "LspDiagnosticsSignError", linehl = nil, numhl = nil }
  )

  vim.fn.sign_define(
    "LspDiagnosticsSignWarning",
    { text = "⚡", texthl = "LspDiagnosticsSignWarning", linehl = nil, numhl = nil }
  )

  vim.fn.sign_define(
    "LspDiagnosticsSignInformation",
    { text = "✦", texthl = "LspDiagnosticsSignInformation", linehl = nil, numhl = nil }
  )

  vim.fn.sign_define(
    "LspDiagnosticsSignHint",
    { text = "", texthl = "LspDiagnosticsSignHint", linehl = nil, numhl = nil }
  )
end

--- Diagnostics handler
local function setup_custom_handlers()
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

local function on_attach(client, bufnr)
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

function M.pre_setup()
  setup_diagnostic_signs()
  setup_custom_handlers()
  -- Ensure that the following LSP's are installed.
  local ensure_installed_servers = { "vim", "lua" }
  for _, server in ipairs(ensure_installed_servers) do
    if not lspinstall.is_server_installed(server) then
      lspinstall.install_server(server)
    end
  end
end
M.pre_setup()

--- Initialize the LSPs
function M.setup()
  local myconfigs = {
    efm = require("_lsp/efm").setup(),
    lua = require("_lsp/sumneko_lua").setup(),
    clangd = require("_lsp/clangd").setup(),
    texlab = require("_lsp/latex").setup(),
    lemminx = require("_lsp/lemminx").setup(),
    grammar_guard = require("_lsp/grammar-guard").setup(),
  }
  setmetatable(myconfigs, {
    __index = function()
      return {}
    end,
  })

  -- get all installed servers
  local servers = lspinstall.installed_servers()
  -- ... and add manually installed servers
  table.insert(servers, "clangd")
  table.insert(servers, "efm")
  table.insert(servers, "texlab")
  table.insert(servers, "grammar_guard")

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  local default_conf = {
    on_init = function(client)
      client.config.flags = {}
      if client.config.flags then
        client.config.flags.allow_incremental_sync = true
      end
    end,
    on_attach = on_attach,
    capabilities = capabilities,
  }
  for _, server in ipairs(servers) do
    local conf = vim.tbl_extend("force", default_conf, myconfigs[server])
    require("lspconfig")[server].setup(conf)
  end
end
M.setup()

function M.post_setup()
  -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
  lspinstall.post_install_hook = function()
    M.setup() -- reload installed servers
    vim.cmd "bufdo e"
  end
end
M.post_setup()

return M
