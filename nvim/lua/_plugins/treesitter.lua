return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = [[:TSUpdate]],
    event = "BufReadPost",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "help",
        "html",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rust",
        "vim",
        "zig",
      },
      highlight = {
        enable = true,
        disable = { "latex", "tex" },
      },
      indent = { enable = true, disable = { "python" } },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
