local lsp_installer = require "nvim-lsp-installer"
local myconfigs = require "_lsp/configs"
local settings = require "_lsp/settings"

settings.ensure_installed()
settings.setup_diagnostic_signs()
settings.setup_custom_handlers()

local capabilities = require("cmp_nvim_lsp").update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

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

lsp_installer.on_server_ready(function(server)
  local opts = vim.tbl_extend("force", default_conf, myconfigs[server.name])

  server:setup(opts)

  vim.cmd [[ do User LspAttachBuffers ]]
end)
