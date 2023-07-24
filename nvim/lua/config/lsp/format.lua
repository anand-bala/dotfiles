local map = vim.keymap.set

local M = {}

---@type PluginLspOpts
M.opts = nil

function M.enabled()
  return M.opts.autoformat
end

function M.enable()
  if not M.opts.autoformat then
    M.opts.autoformat = true
    vim.notify("Enabled format on save", vim.log.levels.INFO, { title = "Format" })
  end
end

function M.disable()
  if M.opts.autoformat then
    M.opts.autoformat = false
    vim.notify("Disabled format on save", vim.log.levels.INFO, { title = "Format" })
  end
end

function M.toggle()
  if M.enabled() then
    M.disable()
  else
    M.enable()
  end
end

---@param client lsp.Client
---@param opts? {force?:boolean}
function M.format_using(client, opts)
  if client == nil then
    return
  end
  opts = opts or {}
  local buf = vim.api.nvim_get_current_buf()
  if M.opts.format_notify then
    local formatters = M.get_formatters(buf)
    M.notify(formatters)
  end

  vim.lsp.buf.format(vim.tbl_deep_extend("force", {
    bufnr = buf,
    id = client.id,
  }, M.opts.format or {}))
end

---@param opts? {force?:boolean}
function M.format(opts)
  opts = opts or {}

  local buf = vim.api.nvim_get_current_buf()
  local formatters = M.get_formatters(buf)
  local client_ids = vim.tbl_map(function(client)
    return client.id
  end, formatters.active)

  if #client_ids == 0 then
    return
  end

  if M.opts.format_notify then
    M.notify(formatters)
  end

  vim.lsp.buf.format(vim.tbl_deep_extend("force", {
    bufnr = buf,
    filter = function(client)
      return vim.tbl_contains(client_ids, client.id)
    end,
  }, M.opts.format or {}))
end

---@param formatters LazyVimFormatters
function M.notify(formatters)
  local lines = { "# Active:" }

  for _, client in ipairs(formatters.active) do
    local line = "- **" .. client.name .. "**"
    if client.name == "null-ls" then
      line = line
        .. " ("
        .. table.concat(
          vim.tbl_map(function(f)
            return "`" .. f.name .. "`"
          end, formatters.null_ls),
          ", "
        )
        .. ")"
    end
    table.insert(lines, line)
  end

  if #formatters.available > 0 then
    table.insert(lines, "")
    table.insert(lines, "# Disabled:")
    for _, client in ipairs(formatters.available) do
      table.insert(lines, "- **" .. client.name .. "**")
    end
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO, {
    title = "Formatting",
    on_open = function(win)
      vim.api.nvim_set_option_value("conceallevel", 3, {
        win = win,
      })
      vim.api.nvim_set_option_value("spell", false, {
        win = win,
      })
      local buf = vim.api.nvim_win_get_buf(win)
      vim.treesitter.start(buf, "markdown")
    end,
  })
end

--- Gets all lsp clients that support formatting.
--- When a null-ls formatter is available for the current filetype,
--- only null-ls formatters are returned.
---@param bufnr integer
---@return LazyVimFormatters
function M.get_formatters(bufnr)
  local ft = vim.bo[bufnr].filetype
  -- check if we have any null-ls formatters for the current filetype
  local null_ls = package.loaded["null-ls"]
      and require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING")
    or {}

  ---@class LazyVimFormatters
  local ret = {
    ---@type lsp.Client[]
    active = {},
    ---@type lsp.Client[]
    available = {},
    null_ls = null_ls,
  }

  ---@type lsp.Client[]
  local clients = vim.lsp.get_active_clients { bufnr = bufnr }
  for _, client in ipairs(clients) do
    if M.supports_format(client) then
      if (#null_ls > 0 and client.name == "null-ls") or #null_ls == 0 then
        table.insert(ret.active, client)
      else
        table.insert(ret.available, client)
      end
    end
  end

  return ret
end

--- Gets all lsp clients that support formatting
--- and have not disabled it in their client config
---@param bufnr integer
---@return lsp.Client[]
function M.get_all_formatters(bufnr)
  local ret = {}
  local clients = vim.lsp.get_active_clients { bufnr = bufnr }
  for _, client in ipairs(clients) do
    if M.supports_format(client) then
      table.insert(ret, client)
    end
  end
  return ret
end

-- Gets all lsp clients that support formatting
-- and have not disabled it in their client config
---@param client lsp.Client
function M.supports_format(client)
  if
    client.config
    and client.config.capabilities
    and client.config.capabilities.documentFormattingProvider == false
  then
    return false
  end
  return client.supports_method "textDocument/formatting"
    or client.supports_method "textDocument/rangeFormatting"
end

---@param opts PluginLspOpts
function M.setup(opts)
  M.opts = opts
end

--- Setup autocmds and mappings for LSP-based formatting
--- @param client lsp.Client
--- @param buf integer
function M.on_attach(client, buf)
  local buf_command = vim.api.nvim_buf_create_user_command
  local ft = vim.bo[buf].filetype

  if client.server_capabilities.documentFormattingProvider then
    local lsp_format = require "config.lsp.format"
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatting", {}),
      buffer = buf,
      callback = function()
        if lsp_format.opts.autoformat then
          lsp_format.format()
        end
      end,
    })

    map("n", "<leader>f", function()
      lsp_format.format { force = true }
    end, {
      desc = "Format the document",
      buffer = buf,
    })
    buf_command(buf, "Format", function()
      local formatters = lsp_format.get_all_formatters(buf)
      vim.ui.select(formatters, {
        prompt = "Select a formatter to use",
        ---@param item lsp.Client
        ---@return string
        format_item = function(item)
          if item.name == "null-ls" then
            local null_ls_fmts =
              require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING")
            return item.name
              .. " ("
              .. table.concat(
                vim.tbl_map(function(f)
                  return "`" .. f.name .. "`"
                end, null_ls_fmts),
                ", "
              )
              .. ")"
          else
            return item.name
          end
        end,
      }, function(choice)
        lsp_format.format_using(choice)
      end)
    end, { desc = "Format the document", force = true })
    buf_command(buf, "FormatToggle", function()
      lsp_format.toggle()
    end, { desc = "Toggle auto-format", force = true })
    buf_command(buf, "ListFormatters", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local formatters = lsp_format.get_formatters(bufnr)
      lsp_format.notify(formatters)
    end, {
      desc = "List the formatters for this buffer",
      force = true,
    })
  end
end

return M
