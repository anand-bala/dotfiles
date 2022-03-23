local util = require "lspconfig/util"
local handlers = require "vim.lsp.handlers"
local debug = require "_utils/debug"
local Path = require "plenary.path"
local uv = vim.loop

vim.g.ltex_ngram_data = "~/opt/ngrams"

LTEX_DICTIONARY = {}

local function load_global_dict()
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
  return LTEX_DICTIONARY
end

function _G.find_ngram_model()
  local ngrams_path = Path:new(vim.g.ltex_ngram_data)

  -- if not ngrams_path:is_dir() then
  --   return
  -- end

  ngrams_path = Path:new(ngrams_path:expand())

  return ngrams_path:absolute()
end

local ltex_ctx = {
  watchers = {},
  client = nil,
}

ltex_ctx.__index = ltex_ctx

function ltex_ctx:new()
  return setmetatable({}, self)
end

function ltex_ctx:readSpellfile(fullpath, out_dict)
  local f = assert(io.open(fullpath, "r"))
  while true do
    local line = f:read "*l"
    if line == nil then
      break
    end
    table.insert(out_dict, line)
  end
  f:close()
end

function ltex_ctx:on_spellfile_change(_, fname)
  local fullpath = vim.fn.fnamemodify(fname, ":p")
  local words = {}
  self:readSpellfile(fullpath, words)
  words = vim.tbl_flatten { words, load_global_dict() }
  self:replaceDictionary { ["en-US"] = vim.fn.uniq(vim.fn.sort(words)) }
end

function ltex_ctx:attach(client)
  self.client = client
  --- Add the new spellfiles and the corresponding watcher.
  local spellfiles = vim.opt.spellfile:get()
  local words = {}
  for _, filename in ipairs(spellfiles) do
    local file = Path:new(filename)
    if file:exists() and file:is_file() then
      local watcher = uv.new_fs_event()
      local fullpath = vim.fn.fnamemodify(filename, ":p")
      self.watchers[fullpath] = watcher
      watcher:start(
        fullpath,
        {},
        vim.schedule_wrap(function(...)
          self:on_spellfile_change(...)
        end)
      )
      self:readSpellfile(fullpath, words)
    end
  end

  words = vim.tbl_flatten { words, load_global_dict() }
  self:updateDictionary { ["en-US"] = vim.fn.uniq(vim.fn.sort(words)) }
end

function ltex_ctx:replaceDictionary(words)
  local client = self.client
  client.config.settings.ltex.dictionary = words
  client.workspace_did_change_configuration(client.config.settings)
end

function ltex_ctx:updateDictionary(words)
  local client = self.client
  local dict = client.config.settings.ltex.dictionary
  for lang, list in pairs(dict) do
    dict[lang] = vim.fn.uniq(vim.fn.sort(vim.tbl_flatten { list, words[lang] }))
  end
  client.workspace_did_change_configuration(client.config.settings)
end

local function addToDictionary(clientid, words)
  for _, word in ipairs(words["en-US"]) do
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
  on_attach = function(client)
    local ctx = ltex_ctx:new()
    client.ltex_ctx = ctx
    ctx:attach(client)
  end,
  settings = {
    ltex = {
      enabled = { "latex", "tex", "markdown" },
      language = "en-US",
      additionalRules = {
        enablePickyRules = true,
        motherTongue = "en-GB",
        languageModel = find_ngram_model(),
      },
      disabledRules = {
        ["en-US"] = {
          "WHITESPACE_RULE",
          "EN_QUOTES",
        },
      },
      dictionary = {
        ["en-US"] = {},
      },
    },
  },
}
