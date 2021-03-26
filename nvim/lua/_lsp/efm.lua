local config_dir = vim.fn.stdpath('config')
local efm_config = config_dir .. "/efm-config.yaml"

return {
    cmd = {'efm-langserver', '-c=' .. efm_config},
    init_options = {documentFormatting = true},
    filetypes = {
        'python', 'yaml', 'json', 'html', 'scss', 'css', 'markdown', 'cmake',
        'lua'
    }
}
