local ls = require "luasnip"
local s = ls.parser.parse_snippet

return {
  -- Header guard
  s(
    { trig = "#once", name = "Header guard", wordTrig = true },
    table.concat({
      "#pragma once",
      "#ifndef ${1}",
      "#define $1",
      "$0",
      "#endif // $1",
    }, "\n")
  ),
}
