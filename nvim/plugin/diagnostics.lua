-- Diagnostic Signs
local signs = { Error = " ", Warn = "⚡", Hint = " ", Info = "✦ " }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config {
  -- Enable underline, use default values
  underline = true,
  -- This will disable virtual text, like doing:
  -- let g:diagnostic_enable_virtual_text = 0
  virtual_text = true,

  -- This is similar to:
  -- let g:diagnostic_show_sign = 1
  -- To configure sign display,
  --  see: ":help vim.lsp.diagnostic.set_signs()"
  signs = true,

  -- This is similar to:
  -- "let g:diagnostic_insert_delay = 1"
  update_in_insert = false,
}
