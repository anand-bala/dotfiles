require '_ui/statusline'
require '_ui/tabline'

vim.o.showtabline = 1
vim.o.tabline = "%!v:lua.TabLine()"
