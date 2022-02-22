require("nvim-treesitter.configs").setup {
  ensure_installed = { "c", "cpp", "python", "rust", "lua", "html", "zig" },
  highlight = { enable = true, disable = { "latex", "tex" } },
  indent = { enable = true, disable = { "python" } },
  matchup = { enable = true },
  playground = { enable = true },
}

