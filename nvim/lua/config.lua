local nvim_lsp = require'nvim_lsp'
nvim_lsp.util.default_config = vim.tbl_extend(
  "force",
  nvim_lsp.util.default_config,
  { log_level = vim.lsp.protocol.MessageType.Warning }
)
