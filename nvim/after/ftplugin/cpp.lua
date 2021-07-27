-- Add triple-slash comments
vim.opt_local.comments:prepend { ":///" }
vim.opt_local.matchpairs:append { "<:>" }

-- Usual clang-format options I set for my projects
vim.opt_local.textwidth = 88
