-- Code Actions
-- {{{
local lsps_actions = {}
-- prepare range params
function make_range_params()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  local line = vim.api.nvim_buf_get_lines(0, row, row+1, true)[1]
  col = vim.str_utfindex(line, col)
  return {
    textDocument = { uri = vim.uri_from_bufnr(0) };
    range = { ["start"] = { line = row, character = col }, ["end"] = { line = row, character = (col + 1) } }
  }
end

-- apply selected codeAction. global to be called from vimL
function apply_code_action(selection)
    local command = lsps_actions[selection]['command']['command']
    local arguments = lsps_actions[selection]['command']['arguments']
    local edit = lsps_actions[selection]['command']['edit']
    local title = lsps_actions[selection]['command']['title']

    if command then
        vim.lsp.buf_request(0, 'workspace/executeCommand', { command = command, arguments = arguments })
    elseif edit then
        -- TODO: not tested
        local bufnr = vim.fn.bufadd((vim.uri_to_fname(uri)))
        apply_text_edits(edit, bufnr)
    end
end

-- send codeAction request. global to be called from mapping
function request_code_actions()
    local bufnr = vim.api.nvim_get_current_buf()
    local buffer_line_diagnostics = all_buffer_diagnostics[bufnr]
    if not buffer_line_diagnostics then
        buf_diagnostics_save_positions(bufnr, diagnostics)
    end
    buffer_line_diagnostics = all_buffer_diagnostics[bufnr]
    if not buffer_line_diagnostics then
        return
    end
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    row = row - 1
    local line_diagnostics = buffer_line_diagnostics[row]
 
    local params = make_range_params()
    params.context = { diagnostics = line_diagnostics }
    local callback = vim.schedule_wrap(function(_, _, actions)
        if not actions then return end
        lsps_actions = actions
        vim.fn[vim.g.nvim_lsp_code_action_menu](lsps_actions, 'v:lua.apply_code_action')
    end)
    vim.lsp.buf_request(0, 'textDocument/codeAction', params, callback)
end
-- }}}
