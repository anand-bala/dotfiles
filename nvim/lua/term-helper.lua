--- Minimal helpers for built-in terminal

local M = {}

function M.open_buffer(opts)
  local defaults = {
    vertical = true,
    size = nil,
    tab = false,
  }
  if type(opts) == "table" then
    opts = vim.tbl_extend("keep", opts, defaults)
  elseif opts == nil then
    opts = defaults
  else
    error "Invalid options for open_buffer. Needs table."
  end

  if opts.tab and opts.vertical then
    error "Can't have `tab` and `vertical` options both true"
  end

  local command = ""
  if opts.tab then
    command = ":tabnew"
    opts.size = nil
  elseif opts.vertical then
    command = ":vnew"
  else
    command = ":new"
  end

  if opts.size and type(opts.size) == "number" and opts.size > 0 then
    command = string.format("%d%s", opts.size, command)
  end

  vim.cmd(command)
end

function M.open_term(args, opts)
  M.open_buffer(opts)

  --- Default shell to use when opening the terminal
  local shell = vim.g.terminal_shell or vim.o.shell
  local prev_shell = vim.o.shell
  vim.o.shell = shell

  assert(type(args) == "string")

  vim.cmd(":terminal " .. args)
  vim.cmd ":startinsert"

  vim.o.shell = prev_shell
end

function M.split_term(args, count)
  M.open_term(args, { vertical = false, size = count })
end

function M.vsplit_term(args, count)
  M.open_term(args, { vertical = true, size = count })
end

function M.tab_term(args)
  M.open_term(args, { tab = true, vertical = false })
end

return M
