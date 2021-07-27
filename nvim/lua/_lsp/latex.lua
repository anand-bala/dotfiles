local util = require "lspconfig/util"

local function forwardSearchConfig()
  local has = vim.fn.has
  local check_exe = vim.fn.executable
  if has "unix" then
    if check_exe "zathura" then
      return { executable = "zathura", args = { "--synctex-forward", "%l:1:%f", "%p" } }
    end
  elseif has "win32" or has "wsl" or (has "unix" and os.getenv "WSLENV") then
    return { executable = "SumatraPDF.exe", args = { "-reuse-instance", "%p", "-forward-search", "%f", "%l" } }
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
  settings = { texlab = { build = { onSave = true }, lint = { onChange = true }, forwardSearch = forwardSearchConfig() } },
}

return {
  setup = function()
    return conf
  end,
}
