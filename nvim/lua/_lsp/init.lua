local M = {}

local myconfigs = require "_lsp/configs"
local settings = require "_lsp/settings"

--- Initialize the LSPs
function M.setup()
  --- Load lspinstall
  local lspinstall = require "lspinstall"
  lspinstall.setup()

  settings.setup_diagnostic_signs()
  settings.setup_custom_handlers()
  -- Ensure that the following LSP's are installed.
  local ensure_installed_servers = { "vim", "lua" }
  for _, server in ipairs(ensure_installed_servers) do
    if not lspinstall.is_server_installed(server) then
      lspinstall.install_server(server)
    end
  end

  -- get all installed servers
  local servers = lspinstall.installed_servers()
  -- ... and add manually installed servers
  table.insert(servers, "clangd")
  table.insert(servers, "efm")
  table.insert(servers, "texlab")

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  local default_conf = {
    on_init = function(client)
      client.config.flags = {}
      if client.config.flags then
        client.config.flags.allow_incremental_sync = true
      end
    end,
    on_attach = settings.on_attach,
    capabilities = capabilities,
  }
  for _, server in ipairs(servers) do
    local conf = vim.tbl_extend("force", default_conf, myconfigs[server])
    require("lspconfig")[server].setup(conf)
  end

  -- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
  lspinstall.post_install_hook = function()
    M.setup() -- reload installed servers
    vim.cmd "bufdo e"
  end
end

return M
