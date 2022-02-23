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
  documentation = {
    border = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        omni = "[Omni]",
        luasnip = "[LuaSnip]",
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        treesitter = "[TS]",
        spell = "[Spell]",
      })[entry.source.name] .. str_check(vim_item.menu)
      return vim_item
    end,
  },
  sources = {
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "treesitter" },
    { name = "emoji" },
    { name = "buffer" },
    { name = "path" },
    { name = "spell" },
    { name = "tags" },
    { name = "calc" },
  },
}

luasnip.filetype_extend("cpp", { "c" })
luasnip.filetype_extend("tex", { "latex" })
luasnip.filetype_set("latex", { "latex", "tex" })
luasnip.filetype_extend("markdown", { "latex", "tex" })

luasnip.snippets = {
  tex = require "_snippets/tex",
  c = require "_snippets/c",
}

require("luasnip/loaders/from_vscode").lazy_load()
