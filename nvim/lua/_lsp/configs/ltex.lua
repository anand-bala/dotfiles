local util = require "lspconfig/util"
local handlers = require "vim.lsp.handlers"
local debug = require "_utils/debug"

LTEX_DICTIONARY = {}

local global_dict_files = vim.api.nvim_get_runtime_file("spell/en*.add", true)
if #LTEX_DICTIONARY == 0 then
  for _, filename in ipairs(global_dict_files) do
    local f = assert(io.open(filename, "r"))
    while true do
      local line = f:read "*l"
      if line == nil then
        break
      end
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
      local line = f:read "*l"
      if line == nil then
        break
      end
      table.insert(LTEX_DICTIONARY, line)
    end
    f:close()
  end
end

local function addToDictionary(clientid, words)
  for _, word in ipairs(words["en-US"]) do
    table.insert(LTEX_DICTIONARY, word)
    vim.cmd((":spellgood %s"):format(word))
  end
  local client = vim.lsp.get_client_by_id(clientid)
  local dict = client.config.settings.ltex.dictionary
  debug.log(vim.inspect(client.config.settings))
  for lang, list in pairs(dict) do
    dict[lang] = vim.tbl_flatten { list, words[lang] }
  end
  debug.log(vim.inspect(dict))
  client.workspace_did_change_configuration(client.config.settings)
end

local function on_execute_command(err, result, ctx)
  if err ~= nil then
    handlers[ctx.method](err, result, ctx)
  end

  debug.log(("ctx: `%s`"):format(vim.inspect(ctx)))

  local params = ctx.params

  if params.command == "_ltex.addToDictionary" then
    addToDictionary(ctx.client_id, ctx.params.arguments[1].words)
  end

  handlers[ctx.method](err, result, ctx)
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
  handlers = {
    ["workspace/executeCommand"] = on_execute_command,
  },
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
