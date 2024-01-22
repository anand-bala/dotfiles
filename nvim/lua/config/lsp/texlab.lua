local M = {}

M.default_builder = "arara"

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

local util = require "lspconfig.util"

local texlab_build_status = vim.tbl_add_reverse_lookup {
  Success = 0,
  Error = 1,
  Failure = 2,
  Cancelled = 3,
}

local texlab_forward_status = vim.tbl_add_reverse_lookup {
  Success = 0,
  Error = 1,
  Failure = 2,
  Unconfigured = 3,
}

function M.buf_build_command(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local texlab_client = util.get_active_client_by_name(bufnr, "texlab")
  local pos = vim.api.nvim_win_get_cursor(0)
  local params = {
    textDocument = { uri = vim.uri_from_bufnr(bufnr) },
    position = { line = pos[1] - 1, character = pos[2] },
  }
  if texlab_client then
    texlab_client.request("textDocument/build", params, function(err, result)
      if err then
        vim.notify(tostring(err), vim.log.levels.ERROR, { title = "Texlab Build" })
        error(tostring(err))
      end
      vim.notify(
        "Build " .. texlab_build_status[result.status],
        vim.log.levels.INFO,
        { title = "Texlab Build" }
      )
    end, bufnr)
  else
    vim.notify(
      "method textDocument/build is not supported by any servers active on the current buffer",
      vim.log.levels.ERROR,
      { title = "LSP" }
    )
  end
end

function M.buf_search_command(bufnr)
  bufnr = util.validate_bufnr(bufnr)
  local texlab_client = util.get_active_client_by_name(bufnr, "texlab")
  local pos = vim.api.nvim_win_get_cursor(0)
  local params = {
    textDocument = { uri = vim.uri_from_bufnr(bufnr) },
    position = { line = pos[1] - 1, character = pos[2] },
  }
  if texlab_client then
    texlab_client.request("textDocument/forwardSearch", params, function(err, result)
      if err then
        vim.notify(
          tostring(err),
          vim.log.levels.ERROR,
          { title = "Texlab Forward Search" }
        )
        error(tostring(err))
      end
      vim.notify(
        "Search " .. texlab_forward_status[result.status],
        vim.log.levels.INFO,
        { title = "Texlab Forward Search" }
      )
    end, bufnr)
  else
    vim.notify(
      "method textDocument/forwardSearch is not supported by any servers active on the current buffer",
      vim.log.levels.ERROR,
      { title = "LSP" }
    )
  end
end

return M
