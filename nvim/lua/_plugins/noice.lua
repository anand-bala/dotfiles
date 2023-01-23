local null_ls_token = nil
local ltex_token = nil

vim.lsp.handlers['$/progress'] = function(_, result, ctx)
  local value = result.value
  if not value.kind then
    return
  end

  local client_id = ctx.client_id
  local name = vim.lsp.get_client_by_id(client_id).name

  if name == 'null-ls' then
    if result.token == null_ls_token then
      return
    end
    if value.title == 'formatting' then
      null_ls_token = result.token
      return
    end
  elseif name == 'ltex' then
    if result.token == ltex_token then
      return
    end
    if value.title == 'Checking document' then
      ltex_token = result.token
      return
    end
  end
end

local M = {
  "folke/noice.nvim",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  event = "VeryLazy",
}

function M.config()
  vim.lsp.handlers["window/showMessage"] = nil

  local focused = true
  vim.api.nvim_create_autocmd("FocusGained", {
    callback = function()
      focused = true
    end,
  })
  vim.api.nvim_create_autocmd("FocusLost", {
    callback = function()
      focused = false
    end,
  })
  require("noice").setup {
    lsp = {
      progress = { enabled = false },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    routes = {
      {
        filter = {
          cond = function()
            return not focused
          end,
        },
        view = "notify_send",
        opts = { stop = false },
      },
      {
        filter = {
          event = "msg_show",
          find = "%d+L, %d+B",
        },
        view = "mini",
      },
    },
    presets = {
      bottom_search = false,
      command_palette = true,
      long_message_to_split = true,
      inc_rename = true,
      cmdline_output_to_split = false,
    },
    commands = {
      all = {
        -- options for the message history that you get with `:Noice`
        view = "split",
        opts = { enter = true, format = "details" },
        filter = {},
      },
    },
    format = {
      level = {
        icons = false,
      },
    },
  }

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function(event)
      vim.schedule(function()
        require("noice.text.markdown").keys(event.buf)
      end)
    end,
  })
end

return M
