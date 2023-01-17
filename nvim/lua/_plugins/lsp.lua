local command = vim.api.nvim_create_user_command
local map = vim.keymap.set

--- Mappings for built-in LSP client
local function lsp_mappings(_, bufnr)
  local lspmap = function(lhs, rhs)
    local lsp_map_opts = { buffer = bufnr, silent = true }
    map("n", lhs, rhs, lsp_map_opts)
  end
  local te = require "telescope.builtin"

  lspmap("K", vim.lsp.buf.hover)
  lspmap("<C-k>", vim.lsp.buf.signature_help)
  lspmap("gd", te.lsp_definitions)
  lspmap("gD", vim.lsp.buf.declaration)
  lspmap("gi", te.lsp_implementations)
  lspmap("gr", te.lsp_references)
  lspmap("<leader>D", vim.lsp.buf.type_definition)

  lspmap("<C-s>", te.lsp_document_symbols)
  lspmap("<leader><Space>", vim.lsp.buf.code_action)
  lspmap("<leader>rn", vim.lsp.buf.rename)

  lspmap("<leader>ld", function()
    vim.diagnostic.open_float(nil, { source = "always" })
  end)
  lspmap("[d", vim.diagnostic.goto_prev)
  lspmap("]d", vim.diagnostic.goto_next)
  vim.api.nvim_buf_create_user_command(0, "Diagnostics", "Telescope diagnostics", {
    force = true,
  })
  command("WorkspaceDiagnostics", "Telescope diagnostics", {
    force = true,
  })

  lspmap("<leader>f", vim.lsp.buf.format)
  command("Format", function()
    vim.lsp.buf.format()
  end, { force = true })
end

local function default_on_attach(client, bufnr)
  lsp_mappings(client, bufnr)
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
      "nvim-telescope/telescope.nvim",
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
      for name, icon in pairs(require("_settings").icons.diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end
      vim.diagnostic.config(opts.diagnostics)

      -- Disable some handlers

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
