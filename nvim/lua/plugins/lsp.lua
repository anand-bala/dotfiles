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

---@class FormatterSpec
---@field exe string
---@field args? string[]
---@field stdin? boolean
---@field cwd? string
---@field no_append? boolean

---@type LazyPluginSpec
local formatter = {
  "mhartington/formatter.nvim",
  event = "BufReadPost",
  opts = {
    -- Enable or disable logging
    logging = true,
    -- Set the log level
    log_level = vim.log.levels.WARN,
  },
  config = function(_, opts)
    opts = vim.tbl_deep_extend("force", opts or {}, {
      ---@type table<string, (fun(): FormatterSpec)[]>
      filetype = {
        lua = {
          require("formatter.filetypes.lua").stylua,
        },
        python = {
          require("formatter.filetypes.python").isort,
          function()
            local util = require "lspconfig.util"
            ---@type FormatterSpec
            local black = require("formatter.filetypes.python").black()
            local bufname = vim.api.nvim_buf_get_name(0)
            vim.list_extend(black.args, {
              "--stdin-filename",
              bufname,
            })
            black.cwd =
              util.root_pattern("pyproject.toml", "setup.cfg", "setup.py", ".git/")(
                bufname
              )

            return black
          end,
        },
        toml = {
          require("formatter.filetypes.toml").taplo,
        },
        yaml = {
          function()
            local yamlfmt = require("formatter.filetypes.yaml").yamlfmt()
            vim.list_extend(yamlfmt.args, {
              "-formatter",
              "-indent=2,retain_line_breaks=true",
            })
            return yamlfmt
          end,
        },
        bash = {
          require("formatter.filetypes.sh").shfmt,
        },
        tex = {
          function()
            local latexindent = require("formatter.filetypes.latex").latexindent()
            vim.list_extend(latexindent.args, {
              "-m",
              "-l",
            })
            return latexindent
          end,
        },
        -- Use the special "*" filetype for defining formatter configurations on
        -- any filetype
        ["*"] = {
          -- "formatter.filetypes.any" defines default configurations for any
          -- filetype
          -- require("formatter.filetypes.any").remove_trailing_whitespace,
        },
      },
    })
    require("formatter").setup(opts)
  end,
}

---@type LazyPluginSpec
local nvim_lint = {
  "mfussenegger/nvim-lint",
  event = "BufReadPost",
  config = function(_, opts)
    require("lint").linters_by_ft = {
      python = {
        -- "ruff",
        "mypy",
      },
      bash = {
        "shellcheck",
      },
      cmake = {
        "cmakelint",
      },
    }
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}

return {
  mason,
  lsp_plugin,
  formatter,
  nvim_lint,
  { "simrat39/rust-tools.nvim", ft = { "rust" } },
  {
    "vigoux/ltex-ls.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    ft = { "tex", "latex" },
  },
}
