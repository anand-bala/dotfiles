local util = require "lspconfig/util"
local Path = require("plenary").path

local function check_local_spellfile()
  local local_spellfile = Path:new "project.utf-8.add"
  if local_spellfile:exists() then
    return ":" .. local_spellfile:normalize(vim.fn.getcwd())
  end
end

return {
  root_dir = function(fname)
    for _, pat in pairs { "root.tex", "main.tex", ".latexmkrc" } do
      local match = util.root_pattern(pat)(fname)
      if match then
        return match
      end
    end
    return vim.fn.getcwd()
  end,

  settings = {
    ltex = {
      enabled = { "latex", "tex", "bib", "markdown" },
      language = "en-US",
      additionalRules = {
        enablePickyRules = true,
        motherTongue = "en",
      },
      trace = { server = "verbose" },
      dictionary = { ["en-US"] = { check_local_spellfile() } },
      disabledRules = { ["en-US"] = { "WHITESPACE_RULE", "EN_QUOTES" } },
      hiddenFalsePositives = {},
    },
  },
}
