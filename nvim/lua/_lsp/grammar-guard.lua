local Path = require("plenary").path
local utils = require "_utils"
local M = {}

function M.register_custom()
  -- hook to nvim-lspconfig
  require("grammar-guard").init()
end

local function get_spellfile()
  local spellfile = vim.opt.spellfile:get()
  if spellfile == nil then
    return {}
  elseif utils.starts_with(spellfile, "./") then
    return { ":" .. tostring(Path:new(vim.fn.getcwd(), spellfile):absolute()) }
  elseif utils.starts_with(spellfile, "/") then
    return { ":" .. spellfile }
  end
  -- Check if ./spell/spellfile.
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
        dictionary = { ["en-US"] = get_spellfile() },
        disabledRules = { ["en-US"] = { "WHITESPACE_RULE" } },
        hiddenFalsePositives = {},
      },
    },
  }
end

return M
