--- Configure Neovim for IDE like settings.
--- @file    _ide.lua
--- @author  Anand Balakrishnan
--
---[[ Setup treesitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = {"c", "cpp", "python", "rust", "lua"},
    highlight = {enable = true},
    indent = {enable = true}
}
---]]
---[[ Initialize the Built-in LSP
require '_lsp'
---]]

---[[ Configuration for nvim-compe
require'compe'.setup {
    enabled = true,
    autocomplete = true,
    debug = false,
    min_length = 1,
    preselect = 'enable',
    throttle_time = 80,
    source_timeout = 200,
    incomplete_delay = 400,
    max_abbr_width = 100,
    max_kind_width = 100,
    max_menu_width = 100,
    documentation = true,

    source = {
        path = true,
        buffer = true,
        calc = true,
        spell = true,
        tags = true,
        onmi = false,
        nvim_lsp = true,
        nvim_lua = true,
        nvim_treesitter = true,
        vsnip = true,
        snippets_nvim = false,
        ultisnips = true,
        emoji = true
    }
}
---]]

