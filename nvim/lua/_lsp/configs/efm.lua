local python_black = { formatCommand = "black --quiet -", formatStdin = true }
local python_isort = { formatCommand = "isort --quiet -", formatStdin = true }

local cmake_format = { formatCommand = "cmake-format -", formatStdin = true }
local cmake_lint = {
  lintCommand = "cmake-lint --suppress-decorations",
  lintStdin = false,
  lintFormats = { "%f:%l: %m" },
}

local stylua = { formatCommand = "stylua --verify -- -", formatStdin = true }

local xmllint = { formatCommand = "xmllint --format -", formatStdin = true }
local yamllint = { lintCommand = "yamllint -f parsable -", lintStdin = true }
local htmlprettier = {
  formatCommand = "./node_modules/.bin/prettier ${--tab-width:tabWidth} ${--single-quote:singleQuote} --parser html",
}

local bibtextidy_cmd = {
  "bibtex-tidy",
  "--omit=abstract,keywords",
  "--curly",
  "--numeric",
  "--space=2",
  "--align=14",
  "--sort",
  "--duplicates=key,doi",
  "--merge=combine",
  "--drop-all-caps",
  "--escape",
  "--sort-fields=title,shorttitle,author,year,month,day,journal,booktitle,location,on,publisher,address,series,volume,number,pages,doi,isbn,issn,url,urldate,copyright,category,note,metadata",
  "--strip-comments",
  "--trailing-commas",
  "--encode-urls",
  "--remove-empty-fields",
}
local bibtextidy = {
  formatCommand = table.concat(bibtextidy_cmd, " "),
  formatStdin = false,
}

local latexindent = {
  formatCommand = "latexindent.pl -l -m",
  formatStdin = false,
}

local zig_fmt = {
  formatCommand = "zig fmt --stdin",
  formatStdin = true,
}

return {
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
  filetypes = {
    "html",
    "python",
    "cmake",
    "lua",
    "xml",
    "yaml",
    "latex",
    "zig",
  },
  root_dir = function(_)
    return vim.fn.getcwd()
  end,
  settings = {
    languages = {
      html = { htmlprettier },
      python = { python_black, python_isort },
      cmake = { cmake_format, cmake_lint },
      lua = { stylua },
      xml = { xmllint },
      yaml = { yamllint },
      bib = { bibtextidy },
      zig = { zig_fmt },
      latex = {latexindent},
      tex = {latexindent},
    },
  },
}
