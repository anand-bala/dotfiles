--- Mason base configuration
---@type LazyPluginSpec
local mason = {
  "williamboman/mason.nvim",
  cmd = "Mason",
  opts = {
    ensure_installed = {
      "stylua",
      "lua-language-server",
      "shellcheck",
      "shfmt",
      "shellharden",
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require "mason-registry"
    mr.refresh(function()
      for _, tool in ipairs(opts.ensure_installed) do
        local p = mr.get_package(tool)
        if not p:is_installed() then
          p:install()
        end
      end
    end)
  end,
}

--- LSP base plugins
---@type LazyPluginSpec
local lsp_plugin = {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
    "folke/neoconf.nvim",
    "mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    {
      "folke/neodev.nvim",
      opts = {
        experimental = { pathStrict = true },
        plugins = { "nvim-dap-ui" },
        types = true,
      },
      ft = { "lua" },
    },
  },
  ---@type PluginLspOpts
  opts = {},
  ---@param opts PluginLspOpts
  config = function(_, opts)
    -- ensure we load neoconf before this is setup.
    -- require("lazy").load { plugins = { "folke/neoconf.nvim" } }

    -- merge options
    opts = vim.tbl_deep_extend("force", opts, require "config.lsp.servers" or {}) or {}

    -- setup autoformat
    require("config.lsp.format").setup(opts)
    -- Setup diagnostics
    require("config.lsp").diagnostics(opts)
    local capabilities = require("config.lsp").update_capabilities(opts)

    local servers = opts.servers or {}

    local function setup(server)
      local server_opts = servers[server] or {}

      server_opts["capabilities"] =
        vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {})
      if opts.setup[server] then
        if opts.setup[server](server, server_opts) then
          return
        end
      elseif opts.setup["*"] then
        if opts.setup["*"](server, server_opts) then
          return
        end
      end
      require("lspconfig")[server].setup(server_opts)
    end

    for server, server_opts in pairs(servers) do
      if server_opts then
        setup(server)
      end
    end
    --
    -- require("mason-lspconfig").setup { ensure_installed = opts.mason or {} }
    require("mason-lspconfig").setup_handlers { setup }
  end,
}

--- Null-ls base plugin configuration
---@type LazyPluginSpec
local null_ls = {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = {
    {
      "williamboman/mason.nvim",
      opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, {
          -- "alex", "proselint", "write-good",
          "vale",
          "jq",
        })
      end,
    },
  },
  event = "BufReadPost",
  opts = function()
    local null_ls = require "null-ls"

    local formatters = {
      null_ls.builtins.formatting.black.with {
        extra_args = { "--line-length=127" },
      },
      null_ls.builtins.formatting.isort,
      null_ls.builtins.formatting.stylua,
      null_ls.builtins.formatting.taplo,
      null_ls.builtins.formatting.mdformat,
      null_ls.builtins.formatting.yamlfmt.with {
        extra_args = {
          "-formatter",
          "-indent=2,retain_line_breaks=true",
        },
      },
      null_ls.builtins.formatting.cmake_format,
      null_ls.builtins.formatting.jq,
      null_ls.builtins.formatting.shfmt,
      null_ls.builtins.formatting.shellharden,
    }

    local diagnostics = {
      -- null_ls.builtins.diagnostics.alex,
      -- null_ls.builtins.diagnostics.proselint,
      -- null_ls.builtins.diagnostics.write_good,
      -- null_ls.builtins.diagnostics.vale,
      -- null_ls.builtins.diagnostics.ruff,
      null_ls.builtins.diagnostics.mypy,
      -- null_ls.builtins.diagnostics.commitlint,
      null_ls.builtins.diagnostics.cmake_lint,
      null_ls.builtins.diagnostics.shellcheck,
    }

    local sources = {
      null_ls.builtins.code_actions.shellcheck,
    }

    for _, fmt in ipairs(formatters) do
      table.insert(sources, fmt)
    end

    for _, diag in ipairs(diagnostics) do
      table.insert(sources, diag)
    end

    return {
      root_dir = require("null-ls.utils").root_pattern(
        ".null-ls-root",
        ".neoconf.json",
        ".vscode",
        ".git"
      ),
      sources = sources,
      on_attach = require("config.lsp").on_attach,
    }
  end,
}

return {
  mason,
  lsp_plugin,
  null_ls,
  { "simrat39/rust-tools.nvim", ft = { "rust" } },
}
