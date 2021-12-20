local M = {}
local cmd = vim.cmd

function M.create_augroup(name, autocmds)
  cmd("augroup " .. name)
  cmd "autocmd!"
  for _, autocmd in ipairs(autocmds) do
    cmd("autocmd " .. autocmd)
  end
  cmd "augroup END"
end

function M.create_buffer_augroup(name, autocmds)
  cmd("augroup " .. name)
  cmd "autocmd! * <buffer>"
  for _, autocmd in ipairs(autocmds) do
    cmd("autocmd " .. autocmd)
  end
  cmd "augroup END"
end

return M
