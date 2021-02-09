local M = {}
local cmd = vim.cmd

function M.create_augroup(name, autocmds)
    cmd('augroup ' .. name)
    cmd('autocmd!')
    for _, autocmd in ipairs(autocmds) do
        cmd('autocmd ' .. table.concat(autocmd, ' '))
    end
    cmd('augroup END')
end

--- Wrapper around nvim_set_keymap, where the option for noremap is set to true.
function M.noremap(mode, lhs, rhs, opts)
  local default_option = {noremap = true}
  if opts == nil then
    opts = {}
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, vim.tbl_extend("keep", opts, default_option))
end

return M
