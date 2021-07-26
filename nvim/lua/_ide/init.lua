--- Configure Neovim for IDE like settings.
--- @file    _ide.lua
--- @author  Anand Balakrishnan
--
---[[ Setup treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"c", "cpp", "python", "rust", "lua", "html", "zig"},
  highlight = {enable = true},
  indent = {enable = true},
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?'
    }
  }
}
---]]
---[[ Initialize the Built-in LSP
require '_lsp'
---]]

---[[ Configuration for nvim-compe
require'compe'.setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = 'enable',
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = {border = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'}},

  source = {
    path = true,
    buffer = true,
    calc = true,
    spell = true,
    tags = true,
    nvim_lsp = true,
    nvim_lua = true,
    nvim_treesitter = true,
    vsnip = true,
    snippets_nvim = false,
    ultisnips = true,
    emoji = true,
    omni = {filetypes = {'tex'}}
  }
}
---]]

---[[ Fuzzy finder
require("telescope").setup {
  defaults = {
    borderchars = {'─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    vimgrep_arguments = {'rg', '--vimgrep', '--smart-case', '--follow', '--hidden'},
    prompt_prefix = "> ",
    selection_caret = "> ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "flex",
    layout_config = {
      prompt_position = "top",
      vertical = {prompt_position = "top"},
      horizontal = {prompt_position = "top"},
      width = 0.8,
      height = 0.8
    },
    file_sorter = require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter = require'telescope.sorters'.get_generic_fuzzy_sorter,
    path_display = {"absolute"},
    winblend = 0,
    color_devicons = true,
    use_less = true,
    set_env = {['COLORTERM'] = 'truecolor'} -- default = nil,
  }
}

---]]
