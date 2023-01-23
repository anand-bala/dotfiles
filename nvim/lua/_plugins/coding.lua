--- Completions, Linting, and Snippets

--- Mappings for nvim-cmp
local function cmp_mappings()
  local luasnip = require "luasnip"
  local cmp = require "cmp"

  local mapping = cmp.mapping.preset.insert {
    ["<CR>"] = cmp.mapping.confirm { select = false },
    ["<C-j>"] = cmp.mapping(function()
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      end
    end, { "i", "s" }),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif cmp.visible() then
        cmp.confirm()
      else
        fallback()
      end
    end, { "i", "s" }),
  }

  return mapping
end

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
      "kdheepak/cmp-latex-symbols",
      --  'jc-doyle/cmp-pandoc-references' ,
      "jmbuhr/cmp-pandoc-references",
      "onsails/lspkind-nvim",
    },
    opts = function()
      local cmp = require "cmp"
      require("lspkind").init()
      return {
        mapping = cmp_mappings(),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        formatting = {
          format = function(_, item)
            local icons = require("_settings").icons.kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "otter" }, -- Quarto completion source
          { name = "path" },
          { name = "latex_symbols" },
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
