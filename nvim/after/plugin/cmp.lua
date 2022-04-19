--- Configuration for nvim-cmp and snippets
local luasnip = require "luasnip"
local cmp = require "cmp"

local function str_check(str)
  if str == nil then
    return ""
  else
    return " -> " .. str
  end
end

cmp.setup {
  mapping = require("_keymaps").cmp_mappings(),
  window = {
    documentation = "native",
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      local menu_names = {
        buffer = "[Buffer]",
        calc = "[Calc]",
        luasnip = "[LuaSnip]",
        nvim_lsp = "[LSP]",
        nvim_lua = "[API]",
        path = "[Path]",
        omni = "[Omni]",
        spell = "[Spell]",
        tags = "[Tag]",
        treesitter = "[TS]",
      }
      local txt = menu_names[entry.source.name] or entry.source.name
      vim_item.menu = txt .. str_check(vim_item.menu)
      return vim_item
    end,
  },
  sources = {
    { name = "buffer" },
    { name = "calc" },
    { name = "luasnip" },
    { name = "nvim_lsp" },
    { name = "nvim_lua" },
    { name = "path" },
    { name = "spell" },
    { name = "tags" },
    { name = "treesitter" },
  },
}

--- LuaSnip setup
luasnip.filetype_extend("cpp", { "c" })
luasnip.filetype_extend("tex", { "latex" })
luasnip.filetype_set("latex", { "latex", "tex" })
luasnip.filetype_extend("markdown", { "latex", "tex" })

luasnip.snippets = {
  tex = require "_snippets/tex",
  c = require "_snippets/c",
}

require("luasnip/loaders/from_vscode").lazy_load()
