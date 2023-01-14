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

local servers = {
  "efm",
  "vimls",
  "sumneko_lua",
  "ltex",
  "lemminx",
  "pyright",
  "rust_analyzer",
  "texlab",
  "clangd",
  "marksman",
}

return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "simrat39/rust-tools.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "williamboman/mason-lspconfig.nvim" },
      {
        "williamboman/mason.nvim",
        opts = {
          ensure_installed = { "stylua", "black", "ruff" },
        },
      },
    },
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
      },
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overriden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
    },
    config = function(_, opts)
      -- diagnostics
      for name, icon in pairs(require("_utils/icons").diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config(opts.diagnostics)

      -- Configure servers
      local myconfigs = require "_lsp/configs"
      require("mason-lspconfig").setup { ensure_installed = servers }
      require("mason-lspconfig").setup_handlers {
        function(server)
          local server_opts = myconfigs[server] or {}
          local on_attach_callbacks = {}

          if server_opts.on_attach ~= nil then
            table.insert(on_attach_callbacks, server_opts.on_attach)
          end
          server_opts.on_attach = on_attach_chain(on_attach_callbacks)

          if server == "rust_analyzer" then
            -- Initialize the LSP via rust-tools instead
            require("rust-tools").setup {
              server = server_opts,
            }
          else
            require("lspconfig")[server].setup(server_opts)
          end
        end,
      }
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    opts = function()
      local null_ls = require "null-ls"

      local formatters = {
        "black",
        "isort",
        "stylua",
        "cmake_format",
      }

      local diagnostics = {
        "alex",
        "proselint",
        "write_good",
      }

      local sources = {}

      for _, fmt in ipairs(formatters) do
        table.insert(sources, null_ls.builtins.formatting[fmt])
      end

      for _, diag in ipairs(diagnostics) do
        table.insert(sources, null_ls.builtins.diagnostics[diag])
      end

      return sources
    end,
  },
}
