local map = vim.api.nvim_set_keymap

map(0, 'n', '<leader>lv', '<cmd>lua TexlabForwardSearch()<CR>', {silent = true})

