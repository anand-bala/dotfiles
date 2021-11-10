--- Configure Neovim for IDE like settings.
--- @file    _ide.lua
--- @author  Anand Balakrishnan
--
---[[ Setup treesitter
require("nvim-treesitter.configs").setup {
  ensure_installed = { "c", "cpp", "python", "rust", "lua", "html", "zig", "latex" },
  highlight = { enable = true, disable = { "latex", "tex" } },
  indent = { enable = true, disable = { "python" } },
  matchup = { enable = true },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = "o",
      toggle_hl_groups = "i",
      toggle_injected_languages = "t",
      toggle_anonymous_nodes = "a",
      toggle_language_display = "I",
      focus_language = "f",
      unfocus_language = "F",
      update = "R",
      goto_node = "<cr>",
      show_help = "?",
    },
  },
}
---]]
---[[ Initialize the Built-in LSP
require "_lsp"
---]]

---[[ Configuration for nvim-cmp and snippets
local luasnip = require "luasnip"
require("cmp").setup {
  mapping = require "_keymaps/completion",
  documentation = {
    border = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = {
    { name = "nvim_lua" },
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "treesitter" },
    { name = "emoji" },
    { name = "buffer" },
    { name = "path" },
    { name = "spell" },
    { name = "tags" },
  },
}

luasnip.filetype_extend("cpp", { "c" })
luasnip.filetype_extend("tex", { "latex" })
luasnip.filetype_set("latex", { "latex", "tex" })
luasnip.filetype_extend("markdown", { "latex", "tex" })

luasnip.snippets = {
  tex = require "_snippets/tex",
}

require("luasnip/loaders/from_vscode").lazy_load()
---]]

---[[ Fuzzy finder
require("telescope").setup {
  defaults = {
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    sorting_strategy = "ascending",
    layout_strategy = "flex",
    layout_config = {
      prompt_position = "top",
      vertical = { prompt_position = "top" },
      horizontal = { prompt_position = "top" },
      width = 0.8,
      height = 0.8,
    },
    path_display = { shorten = 5 },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
}
require("telescope").load_extension "fzf"

---]]

require "_ide/statusline"
require "_ide/diagnostics"

require("term-helper").setup {}
