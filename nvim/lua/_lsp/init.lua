local M = {}

require "_lsp/servers"

local lsp_installer = require "nvim-lsp-installer"

local function ensure_installed()
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

local function setup_custom_handlers()
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

local function default_on_attach(client, bufnr)
  -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  -- vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
  -- if
  --   client.resolved_capabilities.document_formatting
  --   or client.resolved_capabilities.document_range_formatting
  -- then
  -- utils.create_buffer_augroup("lspformat", {
  --   [[BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync(nil, 1000)]], -- Run all formatters at 1000ms timeout
  -- })
  -- end
  require("_keymaps").lsp_mappings(client, bufnr)
end

local function on_attach_chain(callbacks)
  vim.validate {
    callbacks = { callbacks, "table" },
  }

  for _, cb in ipairs(callbacks) do
    vim.validate { cb = { cb, "function" } }
  end
  table.insert(callbacks, 1, default_on_attach)
  return function(client, bufnr)
    for _, cb in ipairs(callbacks) do
      cb(client, bufnr)
    end
  end
end

function M.setup()
  ensure_installed()
  setup_custom_handlers()

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
    capabilities = capabilities,
  }

  lsp_installer.on_server_ready(function(server)
    local myconfigs = require "_lsp/configs"
    local opts = vim.tbl_deep_extend("force", default_conf, myconfigs[server.name])
    local on_attach_callbacks = {}
    if opts.on_attach ~= nil then
      table.insert(on_attach_callbacks, opts.on_attach)
    end
    opts.on_attach = on_attach_chain(on_attach_callbacks)

    if server.name == "rust_analyzer" then
      -- Initialize the LSP via rust-tools instead
      require("rust-tools").setup {
        -- The "server" property provided in rust-tools setup function are the
        -- settings rust-tools will provide to lspconfig during init.            --
        -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
        -- with the user's own settings (opts).
        server = vim.tbl_deep_extend("force", server:get_default_options(), opts),
      }
      if not (opts.autostart == false) then
        server:attach_buffers()
      end
      -- Only if standalone support is needed
      require("rust-tools").start_standalone_if_required()
    else
      server:setup(opts)
    end

    vim.cmd [[ do User LspAttachBuffers ]]
  end)
end

return M
