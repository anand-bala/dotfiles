local util = require 'lspconfig/util'

local forwardSearchConfig
local has = vim.fn.has
local check_exe = vim.fn.executable
if has('unix') then
    if check_exe('zathura') then
        forwardSearchConfig = {
            executable = "zathura",
            args = {"--synctex-forward", "%l:1:%f", "%p"}
        }
    end
elseif has('win32') or (has('unix') and os.getenv('WSLENV')) then
    forwardSearchConfig = {
        executable = "SumatraPDF.exe",
        args = {"-reuse-instance", "%p", "-forward-search", "%f", "%l"}
    }
end

local conf = {
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
            forwardSearch = forwardSearchConfig
        }
    }
}

return {setup = function() return conf end}
