return {
  ---[[ Everyday tools
  { "tpope/vim-obsession" },
  {
    "tpope/vim-abolish",
    config = function()
      local augroup = vim.api.nvim_create_augroup
      local autocmd = vim.api.nvim_create_autocmd

      local function abolish(args)
        -- if vim.fn.exists ":Abolish" == 2 then
        vim.cmd("Abolish " .. table.concat(args, " "))
        -- end
      end

      do
        local abolish_abbrevs = augroup("abolish_abbrevs", {})
        autocmd("VimEnter", {
          group = abolish_abbrevs,
          pattern = "*",
          callback = function()
            abolish { "desparat{e,es,ed,ing,ely,ion,ions,or}", "desperat{}" }
            abolish { "seperat{e,es,ed,ing,ely,ion,ions,or}", "separat{}" }
            abolish { "reciev{e,es,ed,ing}", "receiv{}" }
            abolish { "beleiv{e,es,ed,ing}", "believ{}" }
            abolish { "cal{a,e}nder{,s}", "cal{e}ndar{}" }
            abolish { "{,non}existan{ce,t}", "{}existen{}" }
            abolish { "{,un}nec{ce,ces,e}sar{y,ily}", "{}nec{es}sar{}" }
            abolish { "reproducable", "reproducible" }
            abolish { "rec{co,com,o}mend{,s,ed,ing,ation}", "rec{om}mend{}" }
            abolish { "{,ir}releven{ce,cy,t,tly}", "{}relevan{}" }
          end,
        })
      end
    end,
  },
  { "tpope/vim-fugitive", cmd = "Git" },
  { "junegunn/vim-easy-align", lazy = true, cmd = { "EasyAlign" } },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    config = function(_, opts)
      require("mini.comment").setup(opts or {})
    end,
  },
  { "nvim-lua/plenary.nvim" },

  ---]] Everyday tools

  ---[[ Language specific
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
  ---]] Language specific
}
