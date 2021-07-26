local python_black = {formatCommand = 'black --quiet -', formatStdin = true}
local python_isort = {formatCommand = 'isort --quiet -', formatStdin = true}

local cmake_format = {formatCommand = 'cmake-format -', formatStdin = true}
local cmake_lint = {
  lintCommand = 'cmake-lint --suppress-decorations',
  lintStdin = false,
  lintFormats = {'%f:%l: %m'}
}

local luafmt = {formatCommand = 'lua-format', formatStdin = true}

local xmllint = {formatCommand = 'xmllint --format -', formatStdin = true}

return {
  setup = function()
    return {
      init_options = {documentFormatting = true, documentRangeFormatting = true},
      filetypes = {'python', 'cmake', 'lua', 'xml'},
      settings = {
        languages = {
          python = {python_black, python_isort},
          cmake = {cmake_format, cmake_lint},
          lua = {luafmt},
          xml = {xmllint}
        }
      }
    }
  end
}
