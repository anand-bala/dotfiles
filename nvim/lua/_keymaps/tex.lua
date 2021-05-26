
local function zotero_cite()
  local format = "citep"
  local api_call = 'http://127.0.0.1:23119/better-bibtex/cayw?format='.. format .. '&brackets=1'
  local command = "curl -s " .. vim.fn.shellescape(api_call)
  local handle = io.popen(command)
  local result = handle:read("*a")
  handle:close()
  return result
end

noremap <leader>z "=ZoteroCite()<CR>p
