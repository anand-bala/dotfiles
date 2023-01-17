return {
  -- Lua Dev
  { "folke/neodev.nvim", ft = { "lua" } },
  -- Tex/Markdown
  {
    "lervag/vimtex",
    ft = { "tex", "latex", "bib", "bibtex" },
    config = function()
      vim.g.vimtex_mappings_enabled = 0
      vim.g.vimtex_complete_enabled = 1
      vim.g.vimtex_view_enabled = 0
      vim.g.vimtex_format_enabled = 1
      vim.g.vimtex_toc_config = {
        split_pos = "botright",
        fold_enable = 1,
      }
      vim.g.vimtex_toc_show_preamble = 0
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
  },
  { "preservim/vim-markdown", ft = { "markdown" } },
  -- Rust
  { "rust-lang/rust.vim", ft = { "rust" } },
  -- Kitty.conf
  { "fladson/vim-kitty", ft = { "kitty" } },
}
