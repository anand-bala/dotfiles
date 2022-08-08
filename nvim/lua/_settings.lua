local M = {}

function M.sane_defaults()
  vim.opt.secure = true
  vim.opt.modelines = 0 -- Disable Modelines
  vim.opt.number = true -- Show line numbers
  vim.opt.visualbell = true -- Blink cursor on error instead of beeping (grr)
  vim.opt.undofile = true -- Save undo history
end

function M.formatting()
  vim.opt.encoding = "utf-8" -- Encoding
  vim.opt.wrap = true
  vim.opt.linebreak = true
  vim.opt.textwidth = 120

  vim.opt.formatoptions = "tcqrnj"

  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.softtabstop = 2
  vim.opt.expandtab = true
  vim.opt.shiftround = false
end

function M.visual_text()
  vim.opt.conceallevel = 2

  vim.opt.foldenable = true
  vim.opt.foldminlines = 2
  vim.opt.foldnestmax = 3
  vim.opt.foldlevel = 0
  vim.opt.foldlevelstart = -1
  vim.opt.fillchars = { fold = " ", foldopen = "", foldclose = "" }
  vim.opt.foldcolumn = "auto:3"
  vim.opt.foldtext =
    [[substitute(getline(v:foldstart),'\\t',repeat('\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
  vim.opt.foldopen = "all"
  vim.opt.foldclose = "all"
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

  vim.opt.list = true -- Show non-printable characters.
  vim.opt.listchars = {
    tab = "▸ ",
    extends = "❯",
    precedes = "❮",
    nbsp = "±",
    trail = "·",
  }

  -- Enable break indent
  -- vim.opt.breakindent = true
  -- vim.opt.breakindentopt = {"sbr", mi
  -- vim.opt.showbreak = " "
end

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

function M.gui()
  vim.opt.mouse = "a"
  vim.opt.showmode = false

  -- Split pane settings
  -- Right and bottom splits as opposed to left and top
  vim.opt.splitbelow = true
  vim.opt.splitright = true

  -- Turn on sign column
  vim.wo.signcolumn = "yes"

  -- Turn on global statusline
  vim.opt.laststatus = 3

  vim.cmd [[let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"]]
  vim.cmd [[let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"]]
  vim.opt.termguicolors = true
  vim.opt.background="light"
  vim.cmd [[colorscheme onedarkpro]]
end

function M.setup()
  M.sane_defaults()
  M.formatting()
  M.visual_text()
  M.search_settings()
  M.spelling()
  M.completion()
  M.gui()
end

return M
