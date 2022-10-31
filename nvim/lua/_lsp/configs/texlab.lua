local util = require "lspconfig/util"

vim.g.texlab_builder = "arara"

local function buildConfig()
  local check_exe = vim.fn.executable

  local exec = vim.g.texlab_builder

  if not exec then
    return {}
  end

  if not check_exe(exec) then
    error("Specified LaTeX builder doesn't exist: " .. exec)
  end

  if exec == "latexmk" then
    return {
      onSave = false,
      executable = "latexmk",
      args = { "-pdf", "-interaction=nonstopmode", "-synctex=1" },
    }
  elseif exec == "tectonic" then
    return {
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
    }
  elseif exec == "arara" then
    return {
      onSave = false,
      executable = "arara",
      args = {
        -- Input
        "%f",
      },
    }
  end
end

local function forwardSearchConfig()
  local has = vim.fn.has
  local check_exe = vim.fn.executable
  if has "unix" then
    if check_exe "zathura" then
      return {
        executable = "zathura",
        args = { "--synctex-forward", "%l:1:%f", "%p" },
      }
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
    return util.root_pattern { "root.tex", "main.tex", ".latexmkrc" } (fname)
        or vim.fn.getcwd()
  end,
  single_file_support = false,
  settings = {
    texlab = {
      build = buildConfig(),
      forwardSearch = forwardSearchConfig(),
      latexFormatter = "texlab",
    },
  },
}

return conf
