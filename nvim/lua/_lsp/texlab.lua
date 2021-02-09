local util = require 'lspconfig/util'
local lsp = vim.lsp
local texlabConf = require 'lspconfig/texlab'

local texlab_build_status = vim.tbl_add_reverse_lookup {
    Success = 0,
    Error = 1,
    Failure = 2,
    Unconfigured = 3
}

local function forwardSearchConfig()
    local has = vim.fn.has
    local check_exe = vim.fn.executable
    if has('unix') then
        if check_exe('zathura') then
            return {
                executable = "zathura",
                args = {"--synctex-forward", "%l:1:%f", "%p"}
            }
        end
    elseif has('win32') or (has('unix') and os.getenv('WSLENV')) then
        return {
            executable = "SumatraPDF.exe",
            args = {"-reuse-instance", "%p", "-forward-search", "%f", "%l"}
        }
    end
end

function TexlabForwardSearch()
    local bufnr = vim.api.nvim_get_current_buf()
    local uri = vim.uri_from_bufnr(bufnr);
    local line = vim.fn.line(".");
    local col = vim.fn.col(".");
    local params = {
        textDocument = {uri = uri},
        position = {line = line, character = col}
    }
    lsp.buf_request(bufnr, 'textDocument/forwardSearch', params,
                    function(err, _, result, _)
        if err then error(tostring(err)) end
        print("Search for " .. uri .. ":" .. line .. ":" .. col .. " -- " ..
                  texlab_build_status[result.status])
    end)
end

return {
    root_dir = function(fname)
        for _, pat in pairs({'root.tex', 'main.tex'}) do
            local match = util.root_pattern(pat)(fname)
            if match then return match end
        end
        return vim.fn.getcwd()
    end,
    settings = {
        latex = {
            build = {onSave = false},
            lint = {onChange = true},
            forwardSearch = forwardSearchConfig()
        }
    }
}
