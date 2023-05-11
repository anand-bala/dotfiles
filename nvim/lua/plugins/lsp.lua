--- Mason base configuration
---@type LazyPluginSpec
local mason = {
  "williamboman/mason.nvim",
  cmd = "Mason",
  opts = {
    ensure_installed = {
      "stylua",
      "commitlint",
    },
  },
  config = function(_, opts)
    require("mason").setup(opts)
    local mr = require "mason-registry"
    for _, tool in ipairs(opts.ensure_installed) do
      local p = mr.get_package(tool)
      if not p:is_installed() then
        p:install()
      end
    end
  end,
}

--- LSP base plugins
---@type LazyPluginSpec
local lsp_plugin = {
  "neovim/nvim-lspconfig",
  event = "BufReadPre",
  dependencies = {
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
    {
      "lukas-reineke/lsp-format.nvim",
      config = function()
        require("lsp-format").setup {
          tex = {
            sync = true,
          },
          latex = {
            sync = true,
          },
        }
      end,
    },
  },
  ---@class PluginLspOpts
  opts = {
    -- options for vim.diagnostic.config()
    diagnostics = {
      underline = true,
      update_in_insert = false,
      virtual_text = { spacing = 4, prefix = "●" },
      severity_sort = true,
    },
    -- Automatically format on save
    autoformat = true,
    -- LSP Server Settings
    ---@class _.lspconfig.options
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
    -- setup autoformat
    require("config.lsp").autoformat = opts.autoformat
    -- Setup diagnostics
    require("config.lsp").diagnostics(opts)
    local capabilities = require("config.lsp").update_capabilities()

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
          "black",
          "isort",
          -- "alex", "proselint", "write-good",
          "vale",
          "ruff",
        })
      end,
    },
  },
  event = "BufReadPre",
  opts = function()
    local null_ls = require "null-ls"

    local formatters = {
      "black",
      "isort",
      "stylua",
      "taplo",
      "prettierd",
      "yamlfmt",
    }

    local diagnostics = {
      -- "alex",
      -- "proselint",
      -- "write_good",
      -- "vale",
      "ruff",
      "mypy",
      "commitlint",
    }

    local sources = {}

    for _, fmt in ipairs(formatters) do
      table.insert(sources, null_ls.builtins.formatting[fmt])
    end

    for _, diag in ipairs(diagnostics) do
      table.insert(sources, null_ls.builtins.diagnostics[diag])
    end

    return { sources = sources, on_attach = require("config.lsp").on_attach }
  end,
}

--- LSP UI
---@type LazyPluginSpec
local lsp_ui = {
  "glepnir/lspsaga.nvim",
  cmd = { "Lspsaga" },
  event = { "BufReadPost" },
  config = function()
    require("lspsaga").setup {
      lightbulb = {
        enable = false,
      },
      ui = {
        -- This option only works in Neovim 0.9
        title = true,
        -- Border type can be single, double, rounded, solid, shadow.
        border = "single",
        winblend = 0,
        expand = "",
        collapse = "",
        code_action = "💡",
        incoming = " ",
        outgoing = " ",
        hover = " ",
        kind = {},
      },
    }
  end,
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
    { "nvim-treesitter/nvim-treesitter" },
  },
}

return {
  mason,
  lsp_plugin,
  null_ls,
  lsp_ui,
  { import = "plugins.lang.markdown" },
  { import = "plugins.lang.rust" },
  { import = "plugins.lang.tex" },
}
