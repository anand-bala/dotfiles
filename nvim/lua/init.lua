-- Disable some built-in plugins we don't want
local disabled_built_ins = {
    'gzip', 'man', 'matchit', 'matchparen', 'shada_plugin', 'tarPlugin', 'tar',
    'zipPlugin', 'zip', 'netrwPlugin'
}
for i = 1, 10 do vim.g['loaded_' .. disabled_built_ins[i]] = 1 end

require '_plugins'
require '_ide'
require '_ui'
require '_keymaps'
