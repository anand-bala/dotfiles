require("nvim-lsp-installer").setup {
  ensure_installed = { "vimls", "sumneko_lua" },
}

local function default_on_attach(client, bufnr)
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

local to_be_configured = {
  "efm",
  "vimls",
  "sumneko_lua",
  "ltex",
  "lemminx",
  "pyright",
  "rust_analyzer",
  "texlab",
  "clangd",
}

local myconfigs = require "_lsp/configs"
for _, server in ipairs(to_be_configured) do
  local opts = myconfigs[server]
  local on_attach_callbacks = {}

  if opts.on_attach ~= nil then
    table.insert(on_attach_callbacks, opts.on_attach)
  end
  opts.on_attach = on_attach_chain(on_attach_callbacks)

  if server == "rust_analyzer" then
    -- Initialize the LSP via rust-tools instead
    require("rust-tools").setup {
      server = opts,
    }
  else
    require("lspconfig")[server].setup(opts)
  end
end
