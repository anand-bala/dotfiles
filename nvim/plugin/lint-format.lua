local null_ls = require "null-ls"
local h = require "null-ls.helpers"

local formatters = {
  "black",
  "isort",
  -- "stylua",
  "cmake_format",
}

local diagnostics = {
  "alex",
  "cspell",
  "proselint",
  "write_good",
  "vale",
}

local sources = {}

for _, fmt in ipairs(formatters) do
  table.insert(sources, null_ls.builtins.formatting[fmt])
end

for _, diag in ipairs(diagnostics) do
  table.insert(sources, null_ls.builtins.diagnostics[diag])
end

local latexindent = h.make_builtin {
  name = "latexindent.pl",
  meta = {
    url = "https://github.com/psf/black",
    description = "The uncompromising Python code formatter",
  },
  filetypes = { "tex", "latex" },
  method = null_ls.methods.FORMATTING,
  generator_opts = {
    command = "latexindent.pl",
    args = { "-l", "-m" },
    to_stdin = false,
  },
  factory = h.formatter_factory,
}

table.insert(sources, latexindent)

null_ls.setup {
  sources = sources,
}
