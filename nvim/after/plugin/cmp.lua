--- Configuration for nvim-cmp and snippets
local luasnip = require "luasnip"
local cmp = require("cmp")

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
