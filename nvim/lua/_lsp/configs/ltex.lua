local util = require "lspconfig/util"
local Path = require("plenary").path

LTEX_DICTIONARY = {}

local global_dict_files = vim.api.nvim_get_runtime_file("spell/en*utf-8..add", true)
if #LTEX_DICTIONARY == 0 then
  for _, filename in ipairs(global_dict_files) do
    local f = assert(io.open(filename, "r"))
    while true do
      local line = f:read("*l")
      if line == nil then break end
      table.insert(LTEX_DICTIONARY, line)
    end
    f:close()
  end
end

local spellfiles = vim.opt.spellfile:get()
if #spellfiles > 0 then
  for _, filename in ipairs(spellfiles) do
    local f = assert(io.open(filename, "r"))
    while true do
      local line = f:read("*l")
      if line == nil then break end
      table.insert(LTEX_DICTIONARY, line)
    end
    f:close()
  end
end

return {
  root_dir = function(fname)
    return (
        util.root_pattern {
          "root.tex",
          "main.tex",
          ".latexmkrc",
          "main.md",
        }(fname)
      ) or vim.fn.getcwd()
  end,

  settings = {
    ltex = {
      enabled = { "latex", "tex", "markdown" },
      language = "en-US",
      additionalRules = {
        enablePickyRules = true,
        motherTongue = "en-GB",
      },
      disabledRules = {
        ["en-US"] = {
          "WHITESPACE_RULE",
          "EN_QUOTES",
        },
      },
      dictionary = {
        ["en-US"] = LTEX_DICTIONARY,
      },
    },
  },
}
