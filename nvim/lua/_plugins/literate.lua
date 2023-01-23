return {
  -- Quarto
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = { "markdown", "pandoc", "quarto" },
    opts = {
      lspFeatures = {
        enabled = true,
        languages = { "r", "python", "julia" },
        diagnostics = {
          enabled = true,
          triggers = { "BufWrite" },
        },
        completion = {
          enabled = true,
        },
      },
    },
  },
  -- send code from python/r/qmd docuemts to a terminal
  -- like ipython, R, bash
  {
    "jpalardy/vim-slime",
    keys = {
      { "<c-c><c-c>", "<Plug>SlimeRegionSend", "x" },
      { "<c-c><c-c>", "<Plug>SlimeParagraphSend", "n" },
    },
    ft = { "markdown", "pandoc", "quarto" },
    config = function()
      vim.b.slime_cell_delimiter = "#%%"

      -- -- slime, tmux
      -- vim.g.slime_target = 'tmux'
      -- vim.g.slime_bracketed_paste = 1
      -- vim.g.slime_default_config = { socket_name = "default", target_pane = ".2" }

      -- slime, neovim terminal
      vim.g.slime_target = "neovim"
      vim.g.slime_python_ipython = 1
    end,
  },
}
