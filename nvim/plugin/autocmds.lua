-- Register some custom behavior via autocmds

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Custom filetype mappings
do
  local ft_mappings = augroup("ft_mappings", {})
  autocmd({ "BufRead", "BufNewFile" }, {
    group = ft_mappings,
    pattern = { "*.tex", "*.latex" },
    callback = function()
      vim.opt.filetype = "tex"
    end,
  })
end

-- Custom spellfile for filetypes
do
  local function set_spellfile()
    vim.opt_local.spell = true
    vim.opt_local.spellfile = "project.utf-8.add"
  end

  local ft_spellfile = augroup("ft_spellfile", {})
  autocmd({ "FileType" }, {
    group = ft_spellfile,
    pattern = "markdown,tex",
    callback = set_spellfile,
  })
end

-- Terminal
autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.statuscolumn = ""
  end,
})
