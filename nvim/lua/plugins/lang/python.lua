local mason = {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, { "ruff-lsp" })
  end,
}

-- Setup LSP
local lsp = {
  "neovim/nvim-lspconfig",
  ft = { "python" },
  opts = {
    servers = {
      -- pyright = {
      --   disableOrganizeImports = true,
      --   analysis = {
      --     diagnosticMode = "openFilesOnly",
      --   },
      -- },
      -- pylyzer = {},
      pylsp = {
        settings = {
          pylsp = {
            plugins = {
              autopep8 = { enabled = false },
              yapf = { enabled = false },
              pycodestyle = { enabled = false },
            },
          },
        },
      },
    },
    setup = {
      ruff_lsp = function(_, opts)
        opts.capabilities.hoverProvider = false
        return false
      end,
    },
  },
}

return {
  mason,
  lsp,
}
