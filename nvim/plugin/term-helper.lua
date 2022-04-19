local command = vim.api.nvim_create_user_command

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
