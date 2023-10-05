---@diagnostic disable: missing-fields
--- Completions, Linting, and Snippets

--- Mappings for nvim-cmp
local function cmp_mappings()
  local luasnip = require "luasnip"
  local cmp = require "cmp"
  local cmp_select_opts = { behavior = cmp.SelectBehavior.Select }

  local mapping = cmp.mapping {
    ["<CR>"] = cmp.mapping.confirm { select = false },
    ["<C-y>"] = cmp.mapping.confirm { select = true },
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
    ["<C-d>"] = cmp.mapping.scroll_docs(4),
    ["<Up>"] = cmp.mapping.select_prev_item(cmp_select_opts),
    ["<Down>"] = cmp.mapping.select_next_item(cmp_select_opts),
    ["<C-p>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item(cmp_select_opts)
      else
        cmp.complete()
      end
    end),
    ["<C-n>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item(cmp_select_opts)
      else
        cmp.complete()
      end
    end),
    ["<C-k>"] = cmp.mapping(function(fallback)
      -- Backward
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-j>"] = cmp.mapping(function(fallback)
      -- Forward
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }

  return mapping
end

---@type LazyPluginSpec[]
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
      { "kdheepak/cmp-latex-symbols", ft = { "tex", "latex" } },
      "jmbuhr/cmp-pandoc-references",
      "onsails/lspkind-nvim",
    },
    event = "BufReadPost",
    opts = function()
      local cmp = require "cmp"
      -- require("lspkind").init()
      return {
        mapping = cmp_mappings(),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        formatting = {
          -- fields = { "abbr", "kind", "menu" },
          format = require("lspkind").cmp_format {
            mode = "symbol", -- show only symbol annotations
            -- maxwidth = 50, -- prevent the popup from showing more than provided characters
            ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead
          },
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer", keyword_length = 3 },
          { name = "treesitter" },
          { name = "luasnip", keyword_length = 2 },
        },
      }
    end,
    config = function(_, opts)
      local cmp = require "cmp"
      cmp.setup(opts)

      -- Filetype specific sources

      -- lua
      cmp.setup.filetype("lua", {
        sources = cmp.config.sources {
          { name = "nvim_lua" },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
          { name = "treesitter" },
          { name = "luasnip" },
        },
      })

      -- tex
      cmp.setup.filetype(
        "tex",
        cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "omni" },
          { name = "luasnip" },
          { name = "treesitter" },
          { name = "latex_symbols" },
          { name = "path" },
        }
      )

      -- markdown
      cmp.setup.filetype("markdown", {
        sources = {
          { name = "otter" }, -- Quarto completion source
          { name = "latex_symbols" },
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
          { name = "treesitter" },
          { name = "luasnip" },
        },
      })
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
      luasnip.filetype_extend("pandoc", { "markdown", "latex", "tex" })
      luasnip.filetype_extend("quarto", { "markdown", "latex", "tex" })

      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").lazy_load()
    end,
  },
}
