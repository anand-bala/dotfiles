local on_attach_hook = require("config.lsp").on_attach_hook

vim.opt_local.textwidth = 80
---@diagnostic disable-next-line: param-type-mismatch
vim.opt_local.formatoptions:append "]"
vim.opt_local.formatlistpat = [[^\s*\(\d\+[\]:.)}\t ]\)\|\(\\item \)\s*]]

--- Get the TexlabBuild configuration
local function build_config()
  local check_exe = vim.fn.executable
  local exec = vim.g.texlab_builder or "latexmk"
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

--- Get the TexlabForward configuration
local function forward_search()
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

-- Update the Texlab settings lazily
on_attach_hook(
  ---@param client lsp.Client
  ---@param buffer number
  function(client, buffer)
    local new_settings = vim.tbl_extend("force", client.config.settings or {}, {
      build = build_config(),
      forwardSearch = forward_search(),
    })
    if client["workspace_did_change_configuration"] ~= nil then
      ---@diagnostic disable-next-line: undefined-field
      client.workspace_did_change_configuration(new_settings)
    else
      ---@diagnostic disable-next-line: invisible
      client.notify("workspace/didChangeConfiguration", {
        settings = new_settings,
      })
    end
  end
)

on_attach_hook(function(_, buffer)
  -- Use builtin formatexpr for Markdown and Tex
  vim.bo[buffer].formatexpr = nil
  -- Setup Texlab keymaps
  vim.keymap.set("n", "<leader>lv", "<cmd>TexlabForward<CR>", {
    silent = false,
    buffer = buffer,
    remap = false,
  })

  vim.keymap.set("n", "<leader>ll", "<cmd>TexlabBuild<CR>", {
    silent = false,
    buffer = buffer,
    remap = false,
  })
end)
