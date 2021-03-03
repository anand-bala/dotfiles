local M = {}
local cmd = vim.cmd

function M.create_augroup(name, autocmds)
    cmd('augroup ' .. name)
    cmd('autocmd!')
    for _, autocmd in ipairs(autocmds) do
        cmd('autocmd ' .. table.concat(autocmd, ' '))
    end
    cmd('augroup END')
end

--- Wrapper around nvim_set_keymap, where the option for noremap is set to true.
function M.noremap(mode, lhs, rhs, opts)
    local default_option = {noremap = true}
    if opts == nil then opts = {} end
    vim.api.nvim_set_keymap(mode, lhs, rhs,
                            vim.tbl_extend("keep", opts, default_option))
end

--- Check if a file or directory exists in this path
function M.exists(file)
    local ok, err, code = os.rename(file, file)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end
    return ok, err
end

--- Check if a directory exists in this path
function M.isdir(path)
    -- "/" works on both Unix and Windows
    return M.exists(path .. "/")
end

function M.starts_with(str, start) return str:sub(1, #start) == start end

function M.ends_with(str, ending)
    return ending == "" or str:sub(-#ending) == ending
end

--- Check if the platform is windows or not
function M.is_win()
    return (vim.fn.has('win32') or vim.fn.has('win64')) and
               not vim.fn.has('win32unix')
end

return M
