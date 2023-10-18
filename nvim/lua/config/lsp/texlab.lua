local M = {}

M.default_builder = "latexmk"

if
  vim.fn.has "win32" == 1
  or vim.fn.has "wsl" == 1
  or (vim.fn.has "unix" == 1 and os.getenv "WSLENV" ~= nil)
then
  M.default_forward_search = "sumatrapdf"
elseif vim.fn.has "unix" == 1 then
  M.default_forward_search = "zathura"
end

---@class TexlabBuildConfig
---@field onSave boolean?
---@field forwardSearchAfter boolean?
---@field executable string
---@field args string[]

---@class TexlabForwardSearchConfig
---@field executable string
---@field args string[]

---@type table<string,TexlabBuildConfig>
M.BUILDERS = {
  latexmk = {
    onSave = true,
    executable = "latexmk",
    args = { "-pdf", "-interaction=nonstopmode", "-synctex=1" },
  },
  tectonic = {
    onSave = false,
    executable = "tectonic",
    args = {
      "-X",
      "compile",
      -- Input
      "%f",
      -- Flags
      -- "--synctex",
      -- "--keep-logs",
      -- "--keep-intermediates",
      -- Options
      -- OPTIONAL: If you want a custom out directory,
      -- uncomment the following line.
      --"--outdir out",
      "-Z",
      "search-path=" .. (os.getenv "HOME" .. "/texmf"),
    },
  },
  arara = {
    onSave = true,
    executable = "arara",
    args = {
      -- Input
      "%f",
    },
  },
}

---@type table<string,TexlabForwardSearchConfig>
M.FORWARD_SEARCHERS = {
  zathura = {
    executable = "zathura",
    args = { "--synctex-forward", "%l:1:%f", "%p" },
  },
  sumatrapdf = {
    executable = "SumatraPDF.exe",
    args = { "-reuse-instance", "%p", "-forward-search", "%f", "%l" },
  },
}

--- Get the list of available builders
---@return table<string,TexlabBuildConfig>
function M.get_available_builders()
  ---@type table<string,TexlabBuildConfig>
  local ret = {}
  for key, config in pairs(M.BUILDERS) do
    if vim.fn.executable(config.executable) == 1 then
      ret[key] = config
    end
  end
  return ret
end

--- Get the list of available forward search commands
---@return table<string,TexlabForwardSearchConfig>
function M.get_available_forward_search_methods()
  ---@type table<string,TexlabForwardSearchConfig>
  local ret = {}
  for key, config in pairs(M.FORWARD_SEARCHERS) do
    if vim.fn.executable(config.executable) == 1 then
      ret[key] = config
    end
  end
  return ret
end

--- Get the TexlabBuild configuration
---@return TexlabBuildConfig?
function M.build_config()
  local exec = vim.g.texlab_builder or M.default_builder
  if exec == nil then
    return
  end
  local available = M.get_available_builders()
  local config = available[exec]
  if not config or vim.tbl_isempty(config) then
    return {}
  else
    return config
  end
end

--- Get the TexlabForward configuration
---@return TexlabForwardSearchConfig?
function M.forward_search()
  local exec = vim.g.texlab_forward_search or M.default_forward_search
  if not exec then
    return nil
  end
  local available = M.get_available_forward_search_methods()
  local config = available[exec]
  if not config or vim.tbl_isempty(config) then
    return {}
  else
    return config
  end
end

return M
