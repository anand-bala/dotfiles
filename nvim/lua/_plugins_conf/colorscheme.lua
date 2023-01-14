return {
  { "olimorris/onedarkpro.nvim", lazy = true },
  {
    "shaunsingh/solarized.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000,
  },
}
