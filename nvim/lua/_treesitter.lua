-- [[ Tree sitter configurations ]]
require'nvim-treesitter.configs'.setup {
    ensure_installed = {"c", "cpp", "python", "rust", "lua"},
    highlight = {enable = true},
    indent = {enable = true}
}
