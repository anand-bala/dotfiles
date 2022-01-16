local util = require "lspconfig/util"
local configs = require "lspconfig/configs"

local Path = require("plenary").path

local dictionary_files = {
  ["en"] = {
    Path:new(vim.fn.getcwd(), "project.utf-8.add"),
  },
}

local disabledrules_files = {
  ["en"] = {
    Path:new(vim.fn.getcwd(), "disable.ltex"),
  },
}

local falsepositive_files = {
  ["en"] = {
    Path:new(vim.fn.getcwd(), "falsepositives.ltex"),
  },
}

local new_defaults = {
  dictionary_files = dictionary_files,
  disabledrules_files = disabledrules_files,
  falsepositive_files = falsepositive_files,
}

configs.ltex.default_config = vim.tbl_extend(
  "force",
  configs.ltex.default_config,
  new_defaults
)

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
        motherTongue = "en",
      },
      trace = { server = "verbose" },
      disabledRules = { ["en-US"] = { "WHITESPACE_RULE", "EN_QUOTES" } },
      hiddenFalsePositives = {},
    },
  },
}
