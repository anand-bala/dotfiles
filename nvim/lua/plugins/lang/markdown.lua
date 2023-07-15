local mason = {
  "williamboman/mason.nvim",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, { "markdownlint" })
  end,
}

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
}
