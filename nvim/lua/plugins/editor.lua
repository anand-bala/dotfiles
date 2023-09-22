local markdown = {
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
}

local vimtex = {
  "lervag/vimtex",
  ft = { "tex", "latex", "bib", "bibtex" },
  keys = {
    {
      "<C-t>",
      "<cmd>VimtexTocToggle<CR>",
      mode = "n",
      desc = "Toggle document ToC",
      buffer = true,
    },
  },
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

    return true
  end,
}

return {
  markdown,
  vimtex,
  {
    "anufrievroman/vim-angry-reviewer",
    ft = { "tex", "latex" },
  },
}
