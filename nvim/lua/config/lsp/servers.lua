---@diagnostic disable: missing-fields

local lspconfig_util = require "lspconfig.util"

--- Configure each server and merge it with the `opts` table in for `lspconfig`.
---@class PluginLspOpts
local M = {
  --- LSP Server Settings
  ---@type table<string,lsp.ClientConfig>
  servers = {},

  --- Additional custom setup for LSP servers.
  --- The associated function should return `true` if you don't want this server to be
  --- setup with `lspconfig`.
  ---
  --- Example to setup with typescript.nvim
  --- ```lua
  --- tsserver = function(_, opts)
  ---   require("typescript").setup({ server = opts })
  ---   return true
  --- end,
  --- ```
  --- Specify * to use this function as a fallback for any server
  --- ```lua
  --- ["*"] = function(server, opts) end,
  --- ```
  ---
  ---@type table<string, fun(server:string, opts:lsp.ClientConfig):boolean?>
  setup = {},

  --- Servers to auto install
  ---@type string[]
  mason = {
    "lua-language-server",
    "jsonls",
    "pylsp",
    "ruff-lsp",
    "codelldb",
    "rust-analyzer",
    "markdownlint",
  },

  --- options for vim.diagnostic.config()
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

  --- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
  --- Be aware that you also will need to properly configure your LSP server to
  --- provide the inlay hints.
  inlay_hints = {
    enabled = false,
  },
  --- add any global capabilities here
  capabilities = {},
  --- Automatically format on save
  autoformat = true,
  --- Enable this to show formatters used in a notification
  --- Useful for debugging formatter issues
  format_notify = false,
  --- options for vim.lsp.buf.format
  --- `bufnr` and `filter` is handled by the LazyVim formatter,
  --- but can be also overridden when specified
  format = {
    formatting_options = nil,
    timeout_ms = nil,
  },
}

M.servers = {
  jsonls = {},
  lua_ls = {
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
  pyright = {
    settings = {
      pyright = {
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          diagnosticMode = "workspace",
        },
      },
    },
  },
  -- pylyzer = {},
  -- pylsp = {
  --   settings = {
  --     pylsp = {
  --       configurationSources = { "flake8" },
  --       plugins = {
  --         autopep8 = { enabled = false },
  --         yapf = { enabled = false },
  --         pycodestyle = { enabled = false },
  --         mccabe = { enabled = false },
  --         flake8 = { enabled = true },
  --         pyflakes = { enabled = false },
  --         rope_autoimport = { enabled = false },
  --         jedi_completion = { enabled = false },
  --       },
  --     },
  --   },
  --   capabilities = {
  --     formattingProvider = false,
  --   },
  -- },
  ruff_lsp = {
    capabilities = {
      hoverProvider = false,
    },
  },
  texlab = {
    ---@diagnostic disable-next-line: assign-type-mismatch
    root_dir = function(fname)
      return lspconfig_util.root_pattern(".latexmkrc", "latexindent.yaml")(fname)
        or lspconfig_util.find_git_ancestor(fname)
    end,
    settings = {
      texlab = {
        bibtexFormatter = "none",
        latexFormatter = "latexindent",
        latexindent = {
          ["local"] = "latexindent.yaml",
          modifyLineBreaks = true,
        },
      },
    },
  },
  esbonio = {
    init_options = {
      sphinx = {
        srcDir = "${confDir}",
      },
    },
  },
}

M.setup = {
  rust_analyzer = function(_, opts)
    local mason_registry = require "mason-registry"
    -- rust tools configuration for debugging support
    local codelldb = mason_registry.get_package "codelldb"
    local extension_path = codelldb:get_install_path() .. "/extension/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = vim.fn.has "mac" == 1
        and extension_path .. "lldb/lib/liblldb.dylib"
      or extension_path .. "lldb/lib/liblldb.so"
    local rust_tools_opts = vim.tbl_deep_extend("force", opts, {
      dap = {
        adapter = require("rust-tools.dap").get_codelldb_adapter(
          codelldb_path,
          liblldb_path
        ),
      },
      server = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              features = "all",
            },
            -- Add clippy lints for Rust.
            checkOnSave = true,
            -- Use nightly for rustfmt
            rustfmt = {
              extraArgs = "+nightly",
            },
            -- Use clippy for checking
            check = {
              command = "clippy",
              features = "all",
            },
            -- Enable procedural macro support
            procMacro = {
              enable = true,
            },
          },
        },
      },
    })
    require("rust-tools").setup(rust_tools_opts)
    return true
  end,
  texlab = function(_, opts)
    local texlab_helpers = require "config.lsp.texlab"

    opts.settings.texlab.build = texlab_helpers.build_config()
    opts.settings.texlab.forwardSearch = texlab_helpers.forward_search()
  end,
}

return M
