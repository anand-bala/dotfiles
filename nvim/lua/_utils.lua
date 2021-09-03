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

function M.starts_with(str, start)
  return string.sub(str, 1, string.len(start)) == start
end

function M.ends_with(str, ending)
  return ending == "" or string.sub(str, -string.length(ending)) == ending
end

return M
