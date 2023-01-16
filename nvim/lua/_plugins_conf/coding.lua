--- Completions, Linting, and Snippets
return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-omni",
      "hrsh7th/cmp-path",
      "ray-x/cmp-treesitter",
      "L3MON4D3/LuaSnip",
    },
    opts = function()
      local cmp = require "cmp"
      return {
        mapping = require("_keymaps").cmp_mappings(),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        formatting = {
          format = function(_, item)
            local icons = require("_utils/icons").kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "path" },
          { name = "buffer" },
          { name = "treesitter" },
          { name = "luasnip" },
        },
      }
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local luasnip = require "luasnip"
      luasnip.filetype_extend("cpp", { "c" })
      luasnip.filetype_extend("tex", { "latex" })
      luasnip.filetype_set("latex", { "latex", "tex" })
      luasnip.filetype_extend("markdown", { "latex", "tex" })

      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").lazy_load()
    end,
  },
}
