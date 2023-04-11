--- Completions, Linting, and Snippets

--- Mappings for nvim-cmp
local function cmp_mappings()
  local luasnip = require "luasnip"
  local cmp = require "cmp"

  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  local has_words_before = function()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0
        and vim.api
        .nvim_buf_get_lines(0, line - 1, line, true)[1]
        :sub(col, col)
        :match "%s"
        == nil
  end

  local mapping = cmp.mapping {
    ["<CR>"] = cmp.mapping {
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm { select = true }
        else
          fallback()
        end
      end,
      s = cmp.mapping.confirm { select = true },
      c = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
    },
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-e>"] = cmp.mapping(cmp.mapping.close(), { "i", "c" }),
    ["<C-n>"] = cmp.mapping {
      c = function()
        if cmp.visible() then
          cmp.select_next_item()
        else
          vim.api.nvim_feedkeys(t "<Down>", "n", true)
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end,
    },
    ["<C-p>"] = cmp.mapping {
      c = function()
        if cmp.visible() then
          cmp.select_prev_item()
        else
          vim.api.nvim_feedkeys(t "<Up>", "n", true)
        end
      end,
      i = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end,
    },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
        -- they way you will only jump inside the snippet region
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }

  return mapping
end

---@type LazyPluginSpec
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
            local icons = require("config/icons").kinds
            if icons[item.kind] then
              item.kind = icons[item.kind] .. item.kind
            end
            return item
          end,
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "buffer" },
          { name = "treesitter" },
          { name = "luasnip" },
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

      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_lua").lazy_load()
    end,
  },
}
