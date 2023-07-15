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
  ---@class PluginLspOpts
  opts = {
    -- options for vim.diagnostic.config()
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = {
        spacing = 4,
        source = "if_many",
        -- prefix = "●",
        -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
        -- this only works on a recent 0.10.0 build. Will be set to "?" when not supported
        prefix = "icons",
      },
      severity_sort = true,
    },
    -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
    -- Be aware that you also will need to properly configure your LSP server to
    -- provide the inlay hints.
    inlay_hints = {
      enabled = false,
    },
    -- add any global capabilities here
    capabilities = {},
    -- Automatically format on save
    autoformat = true,
    -- Enable this to show formatters used in a notification
    -- Useful for debugging formatter issues
    format_notify = false,
    -- options for vim.lsp.buf.format
    -- `bufnr` and `filter` is handled by the LazyVim formatter,
    -- but can be also overridden when specified
    format = {
      formatting_options = nil,
      timeout_ms = nil,
    },
    -- LSP Server Settings
    ---@type lspconfig.options
    servers = {
      jsonls = {},
      lua_ls = {
        -- mason = false, -- set to false if you don't want this server to be installed with mason
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
            },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
      },
    },
    -- you can do any additional lsp server setup here
    -- return true if you don't want this server to be setup with lspconfig
    ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
    setup = {
      -- example to setup with typescript.nvim
      -- tsserver = function(_, opts)
      --   require("typescript").setup({ server = opts })
      --   return true
      -- end,
      -- Specify * to use this function as a fallback for any server
      -- ["*"] = function(server, opts) end,
    },
  },
  ---@param opts PluginLspOpts
  config = function(_, opts)
    -- ensure we load neoconf before this is setup.
    local _ = require "neoconf"

    -- setup autoformat
    require("config.lsp.format").setup(opts)
    -- Setup diagnostics
    require("config.lsp").diagnostics(opts)
    local capabilities = require("config.lsp").update_capabilities(opts)

    local servers = opts.servers

    local function setup(server)
      local server_opts = servers[server] or {}
      server_opts.capabilities = capabilities
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

    local mlsp = require "mason-lspconfig"
    local available = mlsp.get_available_servers()

    local ensure_installed = {} ---@type string[]
    for server, server_opts in pairs(servers) do
      if server_opts then
        server_opts = server_opts == true and {} or server_opts
        -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
        if server_opts.mason == false or not vim.tbl_contains(available, server) then
          setup(server)
        else
          ensure_installed[#ensure_installed + 1] = server
        end
      end
    end

    require("mason-lspconfig").setup { ensure_installed = ensure_installed }
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
  event = "BufReadPre",
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
  { import = "plugins.lang.markdown" },
  { import = "plugins.lang.rust" },
  { import = "plugins.lang.tex" },
  { import = "plugins.lang.python" },
}
