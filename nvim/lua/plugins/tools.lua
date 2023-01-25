--- Everyday tools
return {
  { "nvim-lua/plenary.nvim" },
  {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup {
        plugins = {
          marks = false,
        }
      }
    end,
  },
  { "tpope/vim-obsession", cmd = "Obsession" },
  {
    "tpope/vim-abolish",
    event = "InsertEnter",
    config = function()
      local augroup = vim.api.nvim_create_augroup
      local autocmd = vim.api.nvim_create_autocmd

      local function abolish(args)
        -- if vim.fn.exists ":Abolish" == 2 then
        vim.cmd("Abolish " .. table.concat(args, " "))
        -- end
      end

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
    end,
  },
  { "tpope/vim-fugitive", cmd = "Git" },
  { "junegunn/vim-easy-align", cmd = { "EasyAlign" } },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    config = function(_, opts)
      require("mini.comment").setup(opts or {})
    end,
  },

}
