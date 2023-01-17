local M = {}

--- Global keymap settings
function M.keymap()
  local map = vim.keymap.set

  -- Set the leader character.
  -- Personally, I like backslash
  vim.g.mapleader = "\\"

  -- Disable 'hjkl' for movements
  map("", "h", "<nop>", { remap = false })
  map("", "j", "<nop>", { remap = false })
  map("", "k", "<nop>", { remap = false })
  map("", "l", "<nop>", { remap = false })

  -- shifting visual block should keep it selected
  map("v", "<", "<gv", { remap = false })
  map("v", ">", ">gv", { remap = false })

  -- go up/down on visual line
  map("n", "<Down>", "gj", { remap = false })
  map("n", "<Up>", "gk", { remap = false })
  map("v", "<Down>", "gj", { remap = false })
  map("v", "<Up>", "gk", { remap = false })
  map("i", "<Down>", "<C-o>gj", { remap = false })
  map("i", "<Up>", "<C-o>gk", { remap = false })

  -- Yank entire line on Y
  map("n", "Y", "yy", { remap = false })

  -- Escape out of terminal mode to normal mode
  map("t", "<Esc>", "<C-\\><C-n>", { silent = true, remap = false })
end

function M.sane_defaults()
  vim.opt.secure = true
  vim.opt.modelines = 0 -- Disable Modelines
  vim.opt.number = true -- Show line numbers
  vim.opt.visualbell = true -- Blink cursor on error instead of beeping (grr)
  vim.opt.undofile = true -- Save undo history

  -- Fishshell fixes
  if string.match(vim.o.shell, "fish$") then
    vim.g.terminal_shell = "fish"
    vim.opt.shell = "sh"
  end

  vim.cmd "syntax enable"
end

function M.formatting()
  vim.opt.encoding = "utf-8" -- Encoding
  vim.opt.wrap = true
  vim.opt.linebreak = true
  vim.opt.textwidth = 88

  vim.opt.formatoptions = "tcqrnj"

  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.softtabstop = 2
  vim.opt.expandtab = true
  vim.opt.shiftround = false
end

function M.visual_text() end

function M.search_settings()
  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  vim.opt.showmatch = true
end

function M.spelling()
  vim.opt.spelllang = "en_us"
  vim.opt.spell = false
end

function M.completion()
  -- vim.opt.completeopt to have a better completion experience
  vim.opt.completeopt = {
    "menu",
    "menuone",
    "noselect",
  }

  -- Avoid showing message extra message when using completion
  vim.opt.shortmess:append({ c = true }, { I = true })
end

function M.set_dark_mode()
  vim.cmd [[colorscheme onedarkpro]]
  vim.opt.background = "dark"
  vim.cmd [[doautocmd ColorScheme onedarkpro]]
end

function M.set_light_mode()
  vim.cmd [[colorscheme solarized]]
  vim.opt.background = "light"
  vim.cmd [[doautocmd ColorScheme solarized]]
end

function M.gui()
  vim.opt.mouse = "a"
  vim.opt.showmode = false

  -- Split pane settings
  -- Right and bottom splits as opposed to left and top
  vim.opt.splitbelow = true
  vim.opt.splitright = true

  -- Conceal text completely and substiture with custom character
  vim.opt.conceallevel = 2

  -- Setup folds
  vim.opt.foldenable = true
  vim.opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  vim.opt.foldlevelstart = 99
  vim.opt.fillchars = { fold = " ", foldopen = "", foldclose = "" }
  vim.opt.foldcolumn = "auto:3"

  -- Turn on global statusline
  vim.opt.laststatus = 3
  -- Turn on sign column
  vim.wo.signcolumn = "yes"
  -- Customize left column
  vim.opt.statuscolumn = "%= "
      .. "%#SignColumn#"
      .. "%s"
      .. "%= "
      .. "%*"
      .. "%#LineNr#"
      .. "%{%"
      .. "&number ? "
      .. 'printf("%"..len(line("$")).."s", v:lnum)'
      .. ":"
      .. '""'
      .. "%}"
      .. "%= "
      .. "%*"
      .. "%#FoldColumn#" -- highlight group for fold
      .. "%{" -- expression for showing fold expand/colapse
      .. "foldlevel(v:lnum) > foldlevel(v:lnum - 1)" -- any folds?
      .. "? (foldclosed(v:lnum) == -1" -- currently open?
      .. '? ""' -- point down
      .. ':  ""' -- point to right
      .. ")"
      .. ': " "' -- blank for no fold, or inside fold
      .. "}"
      .. "%="
      .. "%*"

  -- Show non-printable characters.
  vim.opt.list = true
  vim.opt.listchars = {
    tab = "▸ ",
    extends = "❯",
    precedes = "❮",
    nbsp = "±",
    trail = "·",
  }

  -- Setup terminal colors correctly
  vim.cmd [[let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"]]
  vim.cmd [[let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"]]
  vim.opt.termguicolors = true

  -- Turn on light mode
  M.set_light_mode()
end

M.icons = {
  diagnostics = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  },
  git = {
    added = " ",
    modified = " ",
    removed = " ",
  },
  kinds = {
    Array = " ",
    Boolean = " ",
    Class = " ",
    Color = " ",
    Constant = " ",
    Constructor = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = " ",
    File = " ",
    Folder = " ",
    Function = " ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = " ",
    Module = " ",
    Namespace = " ",
    Null = "ﳠ ",
    Number = " ",
    Object = " ",
    Operator = " ",
    Package = " ",
    Property = " ",
    Reference = " ",
    Snippet = " ",
    String = " ",
    Struct = " ",
    Text = " ",
    TypeParameter = " ",
    Unit = " ",
    Value = " ",
    Variable = " ",
  },
}

function M.defaults()
  M.sane_defaults()
  M.keymap()
end

function M.post_plugin()
  M.formatting()
  M.visual_text()
  M.search_settings()
  M.spelling()
  M.completion()
  M.gui()
end

return M
