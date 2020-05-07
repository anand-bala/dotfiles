local M = {}

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
                    onSave = true;
                };
                lint = {
                    onChange = true;
                };
            }
        }
    }
end

return M

