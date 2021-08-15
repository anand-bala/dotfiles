local util = require "lspconfig/util"

local function buildConfig()
  local check_exe = vim.fn.executable

  if check_exe "latexmk" then
    return {
      onSave = true,
      executable = "latexmk",
      args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
    }
  elseif check_exe "tectonic" then
    return {
      onSave = true,
      executable = "tectonic",
      args = { "%f", "--synctex", "--keep-logs", "--keep-intermediates" },
    }
  end
end

local function forwardSearchConfig()
  local has = vim.fn.has
  local check_exe = vim.fn.executable
  if has "unix" then
    if check_exe "zathura" then
      return { executable = "zathura", args = { "--synctex-forward", "%l:1:%f", "%p" } }
    end
  elseif has "win32" or has "wsl" or (has "unix" and os.getenv "WSLENV") then
    return {
      executable = "SumatraPDF.exe",
      args = { "-reuse-instance", "%p", "-forward-search", "%f", "%l" },
    }
  end
end

local conf = {
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
    texlab = {
      build = buildConfig(),
      lint = { onChange = true },
      forwardSearch = forwardSearchConfig(),
      latexFormatter = "texlab",
      latexindent = {
        modifyLineBreaks = false,
      },
    },
  },
}

return {
  setup = function()
    return conf
  end,
}
