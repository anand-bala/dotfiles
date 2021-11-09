-- Disable some built-in plugins we don't want
local disabled_built_ins = {
  "matchit",
  "matchparen",
  "shada_plugin",
  "tarPlugin",
  "tar",
  "netrwPlugin",
}

for _, disabled_plugin in ipairs(disabled_built_ins) do
  vim.g["loaded_" .. disabled_plugin] = 1
end

-- Fishshell fixes
if string.match(vim.o.shell, "fish$") then
  vim.g.terminal_shell = "fish"
  vim.o.shell = "sh"
end

vim.cmd "syntax enable"

require "_plugins"

---[[ Sanity settings
vim.o.secure = true
vim.o.modelines = 0 -- Disable Modelines
vim.o.number = true -- Show line numbers
vim.o.ruler = true -- Show file stats
vim.o.visualbell = true -- Blink cursor on error instead of beeping (grr)
vim.o.encoding = "utf-8" -- Encoding

vim.o.wrap = true
vim.o.linebreak = true
vim.o.textwidth = 88 -- Use 88 because 80 is outdated

vim.o.formatoptions = "cqrn"

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.shiftround = false

vim.o.conceallevel = 2
vim.o.foldnestmax = 10
vim.o.foldenable = false
vim.o.foldlevel = 2
vim.o.foldmethod = "syntax"

vim.o.hidden = true -- Allow hidden buffers
vim.o.laststatus = 2 -- Status bar

vim.o.list = true -- Show non-printable characters.
vim.opt.listchars = {
  tab = "▸ ",
  extends = "❯",
  precedes = "❮",
  nbsp = "±",
  trail = "·",
}

-- Searching
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.showmatch = true

-- Spelling
vim.o.spelllang = "en_us"
vim.o.spell = false

-- Interface Settings
-- vim.o.background=dark
vim.o.mouse = "a"
vim.o.showmode = false

-- vim.o.completeopt to have a better completion experience
vim.opt.completeopt = { "menu", "menuone", "noselect" }

-- Avoid showing message extra message when using completion
vim.opt.shortmess:append({ c = true }, { I = true })

-- Split pane settings
-- Right and bottom splits as opposed to left and top
vim.o.splitbelow = true
vim.o.splitright = true

--Enable break indent
vim.o.breakindent = true

--Save undo history
vim.opt.undofile = true

--Decrease update time
-- vim.o.updatetime = 250
vim.wo.signcolumn = "yes"
---]]

---[[ GUI options

vim.cmd [[let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"]]
vim.cmd [[let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"]]
vim.o.termguicolors = true
vim.g.dracula_colorterm = 1
vim.cmd [[colorscheme dracula]]
---]]

require "_keymaps"
require "_ide"

--- Register some custom behavior via autocmds
local augroup = require("_utils").create_augroup

-- Spell check on for the following
augroup("spellceck_ft_specific", {
  [[FileType markdown   setlocal spell]],
  [[FileType gitcommit  setlocal spell]],
  [[FileType tex,latex  setlocal spell]],
})

-- Custom filetype mappings
augroup("ft_mappings", { [[BufRead,BufNewFile *.tex,*.latex  set filetype=tex]] })

-- Make the cursor vertically centered
augroup("vertical_center_cursor", {
  [[BufEnter,WinEnter,WinNew,VimResized *,*.* let &scrolloff=winheight(win_getid())/2]],
})

-- Terminal
augroup("terminal_settings", { [[TermOpen * setlocal nonumber norelativenumber]] })
