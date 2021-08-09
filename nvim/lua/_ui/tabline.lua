-- Separators
local left_separator = "|"
local right_separator = "|"
-- Blank Between Components
local space = " "

-- The provided api nvim_is_buf_loaded filters out all hidden buffers
local is_valid = function(buf_num)
  if not buf_num or buf_num < 1 then
    return false
  end
  local listed = vim.fn.getbufvar(buf_num, "&buflisted") == 1
  local exists = vim.api.nvim_buf_is_valid(buf_num)
  return listed and exists
end

local TrimmedDirectory = function(dir)
  local home = os.getenv "HOME"
  local _, index = string.find(dir, home, 1)
  if index ~= nil and index ~= string.len(dir) then
    -- TODO: Trimmed Home Directory
    return string.gsub(dir, home, "~")
  end
  return dir
end

local get_file_icon = function(name, ext)
  local icon = ""
  if vim.fn.exists "*WebDevIconsGetFileTypeSymbol" == 1 then
    icon = vim.fn.WebDevIconsGetFileTypeSymbol(name)
    return icon
  end
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then
    print "No icon plugin found. Please install 'kyazdani42/nvim-web-devicons'"
    return ""
  end
  icon = devicons.get_icon(name, ext)
  if icon == nil then
    icon = ""
  end
  return icon
end

local getTabLabel = function(n)
  local current_win = vim.api.nvim_tabpage_get_win(n)
  local current_buf = vim.api.nvim_win_get_buf(current_win)
  local file_path = vim.fn.bufname(current_buf)
  local file_name = vim.fn.fnamemodify(file_path, ":f:t")
  local file_ext = vim.fn.fnamemodify(file_name, ":e")
  if string.find(file_name, "term://") ~= nil then
    return " Term"
  end
  if file_name == "" then
    return "No Name"
  end
  local icon = get_file_icon(file_name, file_ext)
  if icon ~= nil then
    return icon .. space .. file_name
  end
  return file_name
end

function _G.TabLine()
  local tabline = ""
  local tab_list = vim.api.nvim_list_tabpages()
  local current_tab = vim.api.nvim_get_current_tabpage()
  for _, val in ipairs(tab_list) do
    local file_name = getTabLabel(val)
    if val == current_tab then
      -- tabline = tabline .. "%#TabLineSelSeparator#" .. left_separator
      tabline = tabline .. "%#TabLineSel #" .. file_name
      tabline = tabline .. " %#TabLineSelSeparator#" .. right_separator
    else
      -- tabline = tabline .. "%#TabLineSeparator#" .. left_separator
      tabline = tabline .. "%#TabLine# " .. file_name
      tabline = tabline .. " %#TabLineSeparator#" .. right_separator
    end
  end
  -- tabline = tabline .. "%="
  -- -- Component: Working Directory
  -- local dir = vim.fn.getcwd()
  -- tabline = tabline .. "%#TabLineSeparator#" .. left_separator ..
  --               "%#Tabline# " .. TrimmedDirectory(dir) ..
  --               "%#TabLineSeparator#" .. right_separator
  -- tabline = tabline .. space
  return tabline
end
