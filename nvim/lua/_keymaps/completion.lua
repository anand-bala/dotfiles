--- Mappings for nvim-cmp

local luasnip = require "luasnip"
local cmp = require "cmp"

local mapping = {
  ["<C-d>"] = cmp.mapping.scroll_docs(-4),
  ["<C-u>"] = cmp.mapping.scroll_docs(4),
  ["<C-e>"] = cmp.mapping.close(),
  ["<CR>"] = cmp.mapping.confirm {
    behavior = cmp.ConfirmBehavior.Replace,
  },
  ["<Tab>"] = cmp.mapping.confirm {
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  },
  ["<C-j>"] = function(fallback)
    if luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
    else
      fallback()
    end
  end,
  ["<C-k>"] = function(fallback)
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end,
}

return mapping
