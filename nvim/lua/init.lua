require '_ide'
require '_treesitter'
require '_statusline'
require '_tabline'

vim.o.showtabline = 1
vim.o.tabline = "%!v:lua.TabLine()"

require '_keymaps'
require '_options'
