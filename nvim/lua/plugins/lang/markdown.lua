return {
  {
    "preservim/vim-markdown",
    ft = { "markdown" },
    config = function(_, _)
      vim.g.vim_markdown_auto_insert_bullets = 0
      vim.g.vim_markdown_autowrite = 1
      vim.g.vim_markdown_conceal = 1
      vim.g.vim_markdown_conceal_code_blocks = 0
      vim.g.vim_markdown_edit_url_in = "vsplit"
      vim.g.vim_markdown_folding_disabled = 1
      vim.g.vim_markdown_follow_anchor = 1
      vim.g.vim_markdown_frontmatter = 1
      vim.g.vim_markdown_math = 1
      vim.g.vim_markdown_new_list_item_indent = 0
      vim.g.vim_markdown_strikethrough = 1
      vim.g.vim_markdown_toc_autofit = 1
      vim.g.vim_markdown_toml_frontmatter = 1

      vim.g.markdown_fenced_languages = { "html", "python", "bash=sh", "R=r" }
    end,
  },

  -- Quarto
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = { "markdown", "pandoc" },
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
    ft = { "markdown", "pandoc" },
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
