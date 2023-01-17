local command = vim.api.nvim_create_user_command
local map = vim.keymap.set

command("Term", function(args)
  require("term-helper").split_term(args.args, args.count)
end, {
  force = true,
  count = true,
  nargs = "*",
})

command("VTerm", function(args)
  require("term-helper").vsplit_term(args.args, args.count)
end, {
  force = true,
  count = true,
  nargs = "*",
})

command("TTerm", function(args)
  require("term-helper").tab_term(args.args)
end, {
  force = true,
  nargs = "*",
})

-- Launch terminal at bottom of window
map("n", "`", "<cmd>Term<CR>", { silent = true, remap = false })
-- Create new terminal vsplit
map("n", "<C-w>|", "<cmd>VTerm<CR>", { silent = true, remap = false })

