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
      --   mason = false,
      --   settings = {
      --     pyright = {
      --       disableOrganizeImports = true,
      --     },
      --     python = {
      --       analysis = {
      --         diagnosticMode = "openFilesOnly",
      --       },
      --     },
      --   },
      -- },
      -- pylyzer = {
      --   mason = false,
      -- },
      pylsp = {
        mason = false,
        settings = {
          pylsp = {
            configurationSources = { "flake8" },
            plugins = {
              autopep8 = { enabled = false },
              yapf = { enabled = false },
              pycodestyle = { enabled = false },
              mccabe = { enabled = false },
              flake8 = { enabled = true },
              rope_autoimport = { enabled = true },
              jedi_completion = { enabled = true },
            },
          },
        },
      },
      ruff_lsp = {
        capabilities = {
          hoverProvider = false,
        },
      },
    },
  },
}

return {
  mason,
  lsp,
}
