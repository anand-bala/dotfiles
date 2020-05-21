local util = require 'nvim_lsp/util'
local lsp = vim.lsp
local texlabConf = require 'nvim_lsp/texlab'

local M = {}

local texlab_build_status = vim.tbl_add_reverse_lookup {
  Success = 0;
  Error = 1;
  Failure = 2;
  Unconfigured = 3;
}

local function forwardSearchConfig()
  local has = vim.fn.has
  local check_exe = vim.fn.executable
  if has('unix') then
    if check_exe('zathura') then
      return {
        executable = "zathura";
        args = { "--synctex-forward", "%l:1:%f", "%p" };
      }
    end
  elseif has('win32') or (has('unix') and os.getenv('WSLENV')) then
    return {
      executable = "SumatraPDF.exe";
      args = { "-reuse-instance", "%p", "-forward-search", "%f", "%l" };
    }
  end
end

function TexlabForwardSearch()
  local bufnr = vim.api.nvim_get_current_buf()
  local params = {
    textDocument = { uri = vim.uri_from_bufnr(bufnr) };
    position = {
      line = vim.fn.line(".");
      character = vim.fn.col(".");
    };
  }
  lsp.buf_request(bufnr, 'textDocument/forwardSearch', params,
      function(err, _, result, _)
        if err then error(tostring(err)) end
        print("Search for " .. bufnr .. ":"  .. texlab_build_status[result.status])
      end)
end

function M.config()
  local lfs = require 'lfs'
  local util = require 'nvim_lsp/util'

  return {
    root_dir=function(fname)
      for _,pat in pairs({'root.tex','main.tex'})  do
        local match = util.root_pattern(pat)(fname)
        if match then return match end
      end
      return lfs.currentdir()
    end;
    settings = {
      latex = {
        build = {
          onSave = false;
        };
        lint = {
          onChange = true;
        };
        forwardSearch = forwardSearchConfig();
      }
    };
  }
end

return M

