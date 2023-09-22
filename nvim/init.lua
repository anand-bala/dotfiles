-- Set some sane defaults
vim.opt.secure = true
vim.opt.modelines = 0 -- Disable Modelines
vim.opt.number = true -- Show line numbers
vim.opt.visualbell = true -- Blink cursor on error instead of beeping (grr)
vim.opt.undofile = true -- Save undo history

-- Fixes for fish shell
if string.match(vim.o.shell, "fish$") then
  vim.g.terminal_shell = "fish"
  vim.opt.shell = "sh"
end

-- Enable vim syntax highlighting
vim.cmd "syntax enable"

-- Default formatting options
vim.opt.encoding = "utf-8" -- Default encoding
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.textwidth = 88

vim.opt.formatoptions = "tcqrn21j"

vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.tabstop = 2 -- Size of a hard tab (which will be expanded)
vim.opt.softtabstop = 2 -- Size of a soft tab
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 2 -- Size of indent

-- Sane searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = true

-- Default spelling settings
vim.opt.spelllang = "en_us"
vim.opt.spell = false

-- Conceal text completely and substiture with custom character
vim.opt.conceallevel = 2 -- Hide * markup for bold and italic

-- Use smarter complete options
-- vim.opt.completeopt to have a better completion experience
vim.opt.completeopt = {
  "menu",
  "menuone",
  "preview",
  "noinsert",
  -- "noselect",
}

-- Avoid showing message extra message when using completion
vim.opt.shortmess:append { W = true, I = true, c = true }
if vim.fn.has "nvim-0.9.0" == 1 then
  vim.opt.splitkeep = "screen"
  vim.opt.shortmess:append { C = true }
end

-- GUI options
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.showmode = false -- Don't show mode since we are using statusline

-- Split pane settings
-- Right and bottom splits as opposed to left and top
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Sane timeout limits
vim.opt.timeout = true
vim.opt.timeoutlen = 300

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

-- Set the leader character.
-- Personally, I like backslash
vim.g.mapleader = "\\"

-- Setup sane keymaps

-- Disable 'hjkl' for movements
-- vim.keymap.set("", "h", "<nop>", { remap = false })
-- vim.keymap.set("", "j", "<nop>", { remap = false })
-- vim.keymap.set("", "k", "<nop>", { remap = false })
-- vim.keymap.set("", "l", "<nop>", { remap = false })

-- shifting visual block should keep it selected
vim.keymap.set("v", "<", "<gv", { remap = false })
vim.keymap.set("v", ">", ">gv", { remap = false })

-- go up/down on visual line
vim.keymap.set("n", "<Down>", "gj", { remap = false })
vim.keymap.set("n", "<Up>", "gk", { remap = false })
vim.keymap.set("v", "<Down>", "gj", { remap = false })
vim.keymap.set("v", "<Up>", "gk", { remap = false })
vim.keymap.set("i", "<Down>", "<C-o>gj", { remap = false })
vim.keymap.set("i", "<Up>", "<C-o>gk", { remap = false })

-- Yank entire line on Y
vim.keymap.set("n", "Y", "yy", { remap = false })

-- Setup lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- Load lazy.nvim plugins
require("lazy").setup("plugins", {
  defaults = { lazy = true },
  install = { colorscheme = { "dayfox" } },
  checker = { enabled = true, notify = false },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = false, -- get a notification when changes are found
  },
  performance = {
    cache = {
      enabled = true,
      -- disable_events = {},
    },
    rtp = {
      disabled_plugins = {
        -- "gzip",
        -- "matchit",
        -- "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        -- "zipPlugin",
      },
    },
  },
})

-- Register some custom behavior via autocmds

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Custom filetype mappings
do
  local ft_mappings = augroup("ft_mappings", {})
  autocmd({ "BufRead", "BufNewFile" }, {
    group = ft_mappings,
    pattern = { "*.tex", "*.latex" },
    callback = function()
      vim.opt.filetype = "tex"
    end,
  })
end

-- Custom spellfile for filetypes
do
  local function set_spellfile()
    vim.opt_local.spell = true
    vim.opt_local.spellfile = "project.utf-8.add"
  end

  local ft_spellfile = augroup("ft_spellfile", {})
  autocmd({ "FileType" }, {
    group = ft_spellfile,
    pattern = "markdown,tex",
    callback = set_spellfile,
  })
end

-- Terminal
autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.statuscolumn = ""
  end,
})

-- LSP default on_attach hooks
do
  local on_attach_hook = require("config.lsp").on_attach_hook
  on_attach_hook(
    require("config.lsp").keymaps,
    { desc = "LSP: setup default keymaps", group = "LspDefaultKeymaps" }
  )
  on_attach_hook(
    require("config.lsp.format").on_attach,
    { desc = "LSP: setup formatting", group = "LspFormattingSetup" }
  )
end

-- Commands to set the quickfix buffer/loclist buffer
do
  vim.api.nvim_create_user_command("Diagnostics", function()
    vim.diagnostic.setloclist { title = "Buffer Diagnostics" }
  end, {
    desc = "Populate location list for this buffer with diagnostics",
    force = true,
  })
  vim.api.nvim_create_user_command("WorkspaceDiagnostics", function()
    vim.diagnostic.setqflist { title = "Workspace Diagnostics" }
  end, {
    desc = "Populate quickfix list for with workspace diagnostics",
    force = true,
  })
end

-- Populate quickfix list when diagnostics change
do
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    callback = function()
      vim.diagnostic.setqflist { title = "WorkspaceDiagnostics", open = false }
    end,
  })
end

-- LSP debug
-- vim.lsp.set_log_level "DEBUG"
