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

local bibtextidy = {
  formatCommand = "bibtex-tidy --curly --numeric --space=2 --tab --align=13 --sort=key --duplicates=key,doi --merge=combine --strip-enclosing-braces --sort-fields=title,shorttitle,author,year,month,day,journal,booktitle,location,on,publisher,address,series,volume,number,pages,doi,isbn,issn,url,urldate,copyright,category,note,metadata --trailing-commas --encode-urls --remove-empty-fields --quiet -",
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
    "bib",
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
    },
  },
}
