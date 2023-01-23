vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.qmd" },
  command = "setfiletype quarto",
})
