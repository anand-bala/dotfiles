-- VimTeX
local vimtex = {
  "lervag/vimtex",
  ft = { "tex", "latex", "bib", "bibtex" },
  keys = {
    {"<C-t>", "<cmd>VimtexTocToggle<CR>", mode = "n", desc = "Toggle document ToC", buffer = true},
  },
  init = function()
    vim.g.vimtex_mappings_enabled = 0
    vim.g.vimtex_complete_enabled = 1
    vim.g.vimtex_view_enabled = 0
    vim.g.vimtex_format_enabled = 1
    vim.g.vimtex_toc_config = {
      split_pos = "botright",
      fold_enable = 1,
    }
    vim.g.vimtex_toc_show_preamble = 0

    vim.g.tex_conceal = "abdgm"
    vim.g.tex_flavor = "latex"
    vim.g.vimtex_syntax_conceal = {
      accents = 1,
      cites = 1,
      fancy = 1,
      greek = 1,
      math_bounds = 1,
      math_delimiters = 1,
      math_fracs = 1,
      math_super_sub = 1,
      math_symbols = 1,
      sections = 0,
      styles = 1,
    }
  end,
}

local texlab = {}

function texlab.build_config()
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

function texlab.forward_search()
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

texlab.config = {
  "neovim/nvim-lspconfig",
  ft = { "tex", "latex", "bib", "bibtex" },
  ---@type PluginLspOpts
  opts = {
    servers = {
      texlab = {
        single_file_support = false,
        settings = {
          texlab = {
            build = texlab.build_config(),
            forwardSearch = texlab.forward_search(),
            bibtexFormatter = "none",
            latexFormatter = "latexindent",
            latexindent = {
              ["local"] = "latexindent.yaml",
              modifyLineBreaks = true,
            },
          },
        },
      },
    },
  },
}

return {
  vimtex,
  texlab.config,
}
