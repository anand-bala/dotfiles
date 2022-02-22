local M = {}

--- Keybindings for nvim
local cmd = vim.cmd
local map = vim.keymap.set

--- Global keymap settings
function M.settings()
  -- Set the leader character.
  -- Personally, I like backslash
  vim.g.mapleader = "\\"
end

--- Mappings for nvim-cmp
function M.cmp_mappings()
  local luasnip = require "luasnip"
  local cmp = require "cmp"

  local mapping = {
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-u>"] = cmp.mapping.scroll_docs(4),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
    },
    ["<Tab>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<C-j>"] = function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
  }

  return mapping
end

--- Mappings for telescope.nvim
function M.telescope_mappings()
  local mappings = {
    i = {
      ["<C-u>"] = false,
      ["<C-d>"] = false,
    },
  }
  return mappings
end

--- Mappings for built-in LSP client
function M.lsp_mappings(client, bufnr)
  local lspmap = function(lhs, rhs)
    local lsp_map_opts = { buffer = bufnr, silent = true }
    map("n", lhs, rhs, lsp_map_opts)
  end
  local te = require "telescope.builtin"

  lspmap("K", vim.lsp.buf.hover)
  lspmap("<C-k>", vim.lsp.buf.signature_help)
  lspmap("gd", te.lsp_definitions)
  lspmap("gD", vim.lsp.buf.declaration)
  lspmap("gi", te.lsp_implementations)
  lspmap("gr", te.lsp_references)
  lspmap("<leader>D", vim.lsp.buf.type_definition)

  lspmap("<C-s>", te.lsp_document_symbols)
  lspmap("<leader><Space>", te.lsp_code_actions)
  lspmap("<leader>rn", vim.lsp.buf.rename)

  lspmap("<leader>ld", function()
    vim.diagnostic.open_float(nil, { source = "always" })
  end)
  lspmap("[d", vim.diagnostic.goto_prev)
  lspmap("]d", vim.diagnostic.goto_next)
  cmd [[command! Diagnostics Telescope diagnostics bufnr=0]]
  cmd [[command! WorkspaceDiagnostics Telescope diagnostics]]

  if client.resolved_capabilities.document_formatting then
    lspmap("<leader>f", vim.lsp.buf.formatting_seq_sync)
    cmd [[command! Format lua vim.lsp.buf.formatting_seq_sync()]]
  elseif client.resolved_capabilities.document_range_formatting then
    lspmap("<leader>f", vim.lsp.buf.range_formatting)
    cmd [[command! Format lua vim.lsp.buf.range_formatting()]]
  end
end

function M.setup()
  M.settings()

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

  ---[[ Searching stuff
  map("n", "<C-f>", function()
    require("telescope.builtin").find_files { follow = true, hidden = true }
  end, { remap = false })

  map("n", "<C-g>", "<cmd>Telescope live_grep<cr>", { remap = false })
  map("n", "<C-b>", "<cmd>Telescope buffers<cr>", { remap = false })
  cmd [[command! Helptags Telescope help_tags]]
  cmd [[command! Buffers  Telescope buffers]]
  -- ]]

  ---[[ Terminal
  -- Escape out of terminal mode to normal mode
  map("t", "<Esc>", "<C-\\><C-n>", { silent = true, remap = false })

  -- Launch terminal at bottom of window
  map("n", "`", "<cmd>Term<CR>", { silent = true, remap = false })
  -- Create new terminal vsplit
  map("n", "<C-w>|", "<cmd>VTerm<CR>", { silent = true, remap = false })
  -- ]]

  local tabline = require "tabline"
  map("n", "bt", tabline.buffer_next, { silent = true, remap = false })
  map("n", "bT", tabline.buffer_previous, { silent = true, remap = false })
end

return M
