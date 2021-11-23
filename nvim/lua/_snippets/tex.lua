local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local parse = ls.parser.parse_snippet

return {
  -- Inline math node
  s({ trig = "im", name = "Inline Math", wordTrig = true }, { t "\\(", i(1), t "\\)" }),
  -- Display Math node
  s(
    { trig = "dm", name = "Display Math", wordTrig = true },
    { t "\\[", i(1), t ".\\]" }
  ),
  -- Left/right delimiters
  s(
    { trig = "lr", name = "left right" },
    { t "\\left", i(1), t " ", i(0), t " ", t "\\right", i(2) }
  ),
  s({ trig = "lr(", name = "left( right)" }, { t "\\left( ", i(0), t " \\right)" }),
  s({ trig = "lr[", name = "left[ right]" }, { t "\\left[ ", i(0), t " \\right]" }),
  s({ trig = "lr|", name = "left| right|" }, { t "\\left| ", i(0), t " \\right|" }),
  s({ trig = "lr{", name = "left{ right}" }, { t "\\left{ ", i(0), t " \\right}" }),
  s({ trig = "lra", name = "langle rangle" }, { t "\\langle ", i(0), t " \\rangle" }),
  -- Emphasis
  s({ trig = "emp", name = "emphasis" }, { t "\\emph{", i(0), t "}" }),

  -- Frame
  parse(
    { trig = "frame", wordTrig = true },
    table.concat({
      "\\begin{frame}[${1:tc}]",
      "\\frametitle{${2:title}}",
      "\\framesubtitle{${3:subtitle}}",
      "$0",
      "\\end{frame}",
    }, "\n")
  ),

  parse(
    { trig = "aln", wordTrig = true },
    table.concat({
      "\\begin{align${1:*}}",
      "$0",
      "\\end{align$1}",
    }, "\n")
  ),
}
