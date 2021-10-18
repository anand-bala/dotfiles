local myconfigs = {
  efm = require "_lsp/configs/efm",
  lua = require "_lsp/configs/sumneko_lua",
  clangd = require "_lsp/configs/clangd",
  texlab = require "_lsp/configs/latex",
  lemminx = require "_lsp/configs/lemminx",
  ltex = require "_lsp/configs/ltex",
  zls = require "_lsp/configs/zls",
}

setmetatable(myconfigs, {

  __index = function()
    return {}
  end,
})

return myconfigs
