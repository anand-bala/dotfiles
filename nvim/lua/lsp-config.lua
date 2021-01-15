local nvim_lsp = require 'lspconfig'

local M = {}

-- Diagnostics

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- Enable underline, use default values
    underline = true,
    -- This will disable virtual text, like doing:
    -- let g:diagnostic_enable_virtual_text = 0
    virtual_text = false,

    -- This is similar to:
    -- let g:diagnostic_show_sign = 1
    -- To configure sign display,
    --  see: ":help vim.lsp.diagnostic.set_signs()"
    signs = true,

    -- This is similar to:
    -- "let g:diagnostic_insert_delay = 1"
    update_in_insert = false,
  }
)

local DiagnosticSeverity = vim.lsp.protocol.DiagnosticSeverity

local loclist_type_map = {
  [DiagnosticSeverity.Error] = 'E',
  [DiagnosticSeverity.Warning] = 'W',
  [DiagnosticSeverity.Information] = 'I',
  [DiagnosticSeverity.Hint] = 'I',
}

function M.get_loclist()
  local bufnr = vim.api.nvim_get_current_buf()
  local buffer_diags = vim.lsp.diagnostic.get(bufnr, nil)

  local items = {}
  local insert_diag = function(diag)
    local pos = diag.range.start
    local row = pos.line
    local col = vim.lsp.util.character_offset(bufnr, row, pos.character)

    -- local line = (vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false) or {""})[1]

    table.insert(items, {
        bufnr = bufnr,
        lnum = row + 1,
        col = col + 1,
        text = "[" .. diag.source .. "] " .. diag.message,
        type = loclist_type_map[diag.severity or DiagnosticSeverity.Error] or 'E',
      })
  end

  for _, diag in ipairs(buffer_diags) do
    insert_diag(diag)
  end

  table.sort(items, function(a, b) return a.lnum < b.lnum end)

  return items
end

-- Completions and on_attach

local conf = {}

-- Configure LSP client when it attaches to buffer
function conf.on_attach(client, bufnr)
    local buf_map = vim.api.nvim_buf_set_keymap
    require'completion'.on_attach()

    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.api.nvim_buf_set_var(bufnr, 'nvim_lsp_buf_active', 1)

    local mapping_opts = {}
    mapping_opts['silent'] = true
    mapping_opts['noremap'] = true

    local function lsp_nmap(capability, lhs, rhs)
        if capability then
            buf_map(bufnr, 'n', lhs, rhs, mapping_opts)
        end
    end
    local rcaps = client.resolved_capabilities

    lsp_nmap(rcaps.document_formatting, '<Plug>(nvim-lsp-formatting)', '<cmd>lua vim.lsp.buf.formatting()<CR>')

    lsp_nmap(rcaps.hover, '<Plug>(nvim-lsp-hover)', '<cmd>lua vim.lsp.buf.hover()<CR>')

    lsp_nmap(rcaps.implementation, '<Plug>(nvim-lsp-implementation)', '<cmd>lua vim.lsp.buf.implementation()<CR>')
end

local function setup_lsp(client, config)
    local lsp_config = vim.tbl_extend("keep", config, conf)
    client.setup(lsp_config)
end

function M.setup()
  setup_lsp(nvim_lsp.clangd, {
    init_options = {
      clangdFileStatus = true
    }
  })
  setup_lsp(nvim_lsp.pyls, {
      settings = {
        python = { workspaceSymbols = { enabled = true }},
        pyls = {
          configurationSources = { "flake8" },
          pyls_mypy = {enabled = true},
        },
      },
  })
  setup_lsp(nvim_lsp.julials, {
    filetypes = { "julia" };
    root_dir = function(fname)
      return nvim_lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end;
  })

  setup_lsp(nvim_lsp.texlab, require'lsp-texlab'.config())

  setup_lsp(nvim_lsp.sumneko_lua, {
    settings = {
      Lua = { diagnostics = {globals = {"vim"}}}
    }})
  setup_lsp(nvim_lsp.vimls, {})
end

return M
