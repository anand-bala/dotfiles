-- Minimal helpers for built-in terminal

local cmd = vim.api.nvim_create_user_command
local map = vim.keymap.set

local term_helper = {}

function term_helper.open_buffer(opts)
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

function term_helper.open_term(args, opts)
  term_helper.open_buffer(opts)

  --- Default shell to use when opening the terminal
  local shell = vim.g.terminal_shell or vim.o.shell
  local prev_shell = vim.o.shell
  vim.o.shell = shell

  assert(type(args) == "string")

  vim.cmd(":terminal " .. args)
  vim.cmd ":startinsert"

  vim.o.shell = prev_shell
end

function term_helper.split_term(args, count)
  term_helper.open_term(args, { vertical = false, size = count })
end

function term_helper.vsplit_term(args, count)
  term_helper.open_term(args, { vertical = true, size = count })
end

function term_helper.tab_term(args)
  term_helper.open_term(args, { tab = true, vertical = false })
end

cmd("Term", function(args)
  term_helper.split_term(args.args, args.count)
end, {
  force = true,
  count = true,
  nargs = "*",
})

cmd("VTerm", function(args)
  term_helper.vsplit_term(args.args, args.count)
end, {
  force = true,
  count = true,
  nargs = "*",
})

cmd("TTerm", function(args)
  term_helper.tab_term(args.args)
end, {
  force = true,
  nargs = "*",
})

-- Launch terminal at bottom of window
map("n", "`", "<cmd>Term<CR>", { silent = true, remap = false })
-- Create new terminal vsplit
map("n", "<C-w>|", "<cmd>VTerm<CR>", { silent = true, remap = false })

-- Escape out of terminal mode to normal mode
map("t", "<Esc>", "<C-\\><C-n>", { silent = true, remap = false })
