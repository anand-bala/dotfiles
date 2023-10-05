local onattach = require("config.lsp").on_attach_hook

vim.opt.textwidth = 88

onattach(function(client, buffer)
  vim.lsp.inlay_hint(buffer, false)
end, {
  desc = "disable LSP inlay hints for Rust. Use rust-tools.",
})
