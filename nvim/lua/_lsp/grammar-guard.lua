local Path = require("plenary").path
local utils = require "_utils"
local M = {}

function M.register_custom()
  -- hook to nvim-lspconfig
  require("grammar-guard").init()
end

function M.setup()
  return {
    settings = {
      ltex = {
        enabled = { "latex", "tex", "bib", "markdown" },
        language = "en-US",
        diagnosticSeverity = "information",
        setenceCacheSize = 2000,
        additionalRules = {
          enablePickyRules = true,
          motherTongue = "en",
        },
        trace = { server = "verbose" },
        dictionary = { ["en-US"] = {} },
        disabledRules = { ["en-US"] = { "WHITESPACE_RULE" } },
        hiddenFalsePositives = {},
      },
    },
  }
end

return M
