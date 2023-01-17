return {
  -- Everyday tools
  { "tpope/vim-obsession", cmd = "Obsession" },
  {
    "tpope/vim-abolish",
    event = "InsertEnter",
    config = function()
      local augroup = vim.api.nvim_create_augroup
      local autocmd = vim.api.nvim_create_autocmd

      local function abolish(args)
        -- if vim.fn.exists ":Abolish" == 2 then
        vim.cmd("Abolish " .. table.concat(args, " "))
        -- end
      end

      local abolish_abbrevs = augroup("abolish_abbrevs", {})
      autocmd("VimEnter", {
        group = abolish_abbrevs,
        pattern = "*",
        callback = function()
          abolish { "desparat{e,es,ed,ing,ely,ion,ions,or}", "desperat{}" }
          abolish { "seperat{e,es,ed,ing,ely,ion,ions,or}", "separat{}" }
          abolish { "reciev{e,es,ed,ing}", "receiv{}" }
          abolish { "beleiv{e,es,ed,ing}", "believ{}" }
          abolish { "cal{a,e}nder{,s}", "cal{e}ndar{}" }
          abolish { "{,non}existan{ce,t}", "{}existen{}" }
          abolish { "{,un}nec{ce,ces,e}sar{y,ily}", "{}nec{es}sar{}" }
          abolish { "reproducable", "reproducible" }
          abolish { "rec{co,com,o}mend{,s,ed,ing,ation}", "rec{om}mend{}" }
          abolish { "{,ir}releven{ce,cy,t,tly}", "{}relevan{}" }
        end,
      })
    end,
  },
  { "tpope/vim-fugitive", cmd = "Git" },
  { "junegunn/vim-easy-align", cmd = { "EasyAlign" } },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    config = function(_, opts)
      require("mini.comment").setup(opts or {})
    end,
  },
  { "nvim-lua/plenary.nvim" },

  -- Folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    lazy = false,
    keys = {
      {
        "zr",
        function()
          require("ufo").openFoldsExceptKinds()
        end,
        "n",
      },
      {
        "zR",
        function()
          require("ufo").openAllFolds()
        end,
        "n",
      },
      {
        "zM",
        function()
          require("ufo").closeAllFolds()
        end,
        "n",
      },
      {
        "zm",
        function()
          require("ufo").closeFoldsWith()
        end,
        "n",
      },
    },
    config = function()
      local ftMap = {
        git = "",
      }

      local function customizeSelector(bufnr)
        local function handleFallbackException(err, providerName)
          if type(err) == "string" and err:match "UfoFallbackException" then
            return require("ufo").getFolds(bufnr, providerName)
          else
            return require("promise").reject(err)
          end
        end

        return require("ufo")
          .getFolds(bufnr, "lsp")
          :catch(function(err)
            return handleFallbackException(err, "treesitter")
          end)
          :catch(function(err)
            return handleFallbackException(err, "indent")
          end)
      end

      require("ufo").setup {
        provider_selector = function(bufnr, filetype, buftype)
          return ftMap[filetype] or customizeSelector
        end,
      }
    end,
  },

  -- Colorscheme
  {
    "olimorris/onedarkpro.nvim",
    config = function()
      local odp = require "onedarkpro"
      local colors = require("onedarkpro.helpers").get_colors "onedark"
      odp.setup {
        highlights = {
          Conceal = { bg = colors.bg, fg = colors.fg },
        },
      }
    end,
  },
  {
    "shaunsingh/solarized.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000,
    config = function()
      vim.g.solarized_borders = true
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = [[:TSUpdate]],
    event = "BufReadPost",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "help",
        "html",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rust",
        "vim",
        "zig",
      },
      highlight = {
        enable = true,
        disable = { "latex", "tex" },
      },
      indent = { enable = true, disable = { "python" } },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
