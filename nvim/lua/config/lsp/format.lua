local map = vim.keymap.set
local command = vim.api.nvim_create_user_command

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

---@param opts? {force?:boolean}
function M.format(opts)
  opts = opts or {}

  local buf = vim.api.nvim_get_current_buf()
  local formatters = M.get_formatters(buf)
  local client_ids = vim.tbl_map(function(client)
    return client.id
  end, formatters.active)

  if M.opts.format_notify then
    M.notify(formatters)
  end

  -- prefer formatter.nvim
  if not vim.tbl_isempty(formatters.formatter_nvim) then
    vim.cmd [[Format]]
  end

  if #client_ids > 0 then
    vim.lsp.buf.format(vim.tbl_deep_extend("force", {
      bufnr = buf,
      filter = function(client)
        return vim.tbl_contains(client_ids, client.id)
      end,
    }, M.opts.format or {}))
  end
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

  if
    formatters.formatter_nvim ~= nil
    and not vim.tbl_isempty(formatters.formatter_nvim)
  then
    local line = "- ** formatter.nvim **"
      .. " ("
      .. table.concat(
        vim.tbl_map(function(f)
          return "`" .. f().exe .. "`"
        end, formatters.formatter_nvim),
        ", "
      )
      .. ")"
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

  -- check if we have any formatter.nvim formatters for the current filetype
  local formatter_nvim = package.loaded["formatter"]
      and require("formatter.config").formatters_for_filetype(ft)
    or {}

  ---@class LazyVimFormatters
  local ret = {
    ---@type lsp.Client[]
    active = {},
    ---@type lsp.Client[]
    available = {},
    null_ls = null_ls,
    formatter_nvim = formatter_nvim,
  }

  ---@type lsp.Client[]
  local clients = vim.lsp.get_clients { bufnr = bufnr }
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

-- Gets all lsp clients that support formatting
-- and have not disabled it in their client config
---@param client lsp.Client
function M.supports_format(client)
  if
    client.config
    and client.config.capabilities
    and (
      client.config.capabilities.documentFormattingProvider == false
      or client.config.capabilities.documentFormattingProvider == nil
    )
  then
    return false
  end
  return client.supports_method "textDocument/formatting"
    or client.supports_method "textDocument/rangeFormatting"
end

---@param opts PluginLspOpts
function M.setup(opts)
  M.opts = opts

  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("LspFormatOnWrite", {}),
    pattern = { "*" },
    callback = function()
      if M.opts.autoformat then
        M.format()
      end
    end,
  })

  map("n", "<leader>f", function()
    M.format { force = true }
  end, {
    desc = "Format the document",
  })
  command("FormatToggle", function()
    M.toggle()
  end, { desc = "Toggle auto-format", force = true })
  command("ListFormatters", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local formatters = M.get_formatters(bufnr)
    M.notify(formatters)
  end, {
    desc = "List the formatters for this buffer",
    force = true,
  })
end

return M
