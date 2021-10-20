local ls = require "luasnip"
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

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
}
