local map = vim.api.nvim_buf_set_keymap

-- The following mappings simplify navigation when viewing help:
-- * Press Enter to jump to the subject (topic) under the cursor.
-- * Press Backspace to return from the last jump.
-- * Press s to find the next subject, or S to find the previous subject.
-- * Press o to find the next option, or O to find the previous option.

map(0, 'n', '<CR>', '<C-]>')
map(0, 'n', '<BS>', '<C-o>')
