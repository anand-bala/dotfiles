local utils = require "_utils"

local M = {}

function M.file_readonly()
  if vim.bo.filetype == "help" then
    return ""
  end
  if vim.bo.readonly == true then
    return " "
  end
  return ""
end

function M.file_name()
  if vim.bo.filetype == "fugitive" then
    return "fugitive "
  elseif vim.bo.filetype == "fugitiveblame" then
    return "git blame "
  elseif vim.bo.filetype == "floaterm" then
    return "terminal "
  end
  local file = vim.fn.expand "%:f"
  if vim.fn.empty(file) == 1 then
    file = ""
  elseif utils.starts_with(file, "term://") then
    file = "terminal"
  end
  if string.len(M.file_readonly()) ~= 0 then
    file = file .. M.file_readonly()
  end
  if vim.bo.modifiable then
    if vim.bo.modified then
      file = file .. "   "
    end
  end
  return file .. " "
end

-- format print current file size
function M.format_file_size()
  local size = vim.fn.line "$"
  if size == 0 or size == -1 or size == -2 then
    return ""
  end
  if size < 1000 then
    size = size
  else
    size = string.format("%.1f", size / 1000) .. "K"
  end
  return size .. " "
end

function M.get_file_size()
  local file = vim.fn.expand "%:p"
  if string.len(file) == 0 then
    return ""
  end
  return M.format_file_size()
end

local icon_colors = {
  Brown = "#905532",
  Aqua = "#3AFFDB",
  Blue = "#689FB6",
  Darkblue = "#44788E",
  Purple = "#834F79",
  Red = "#AE403F",
  Beige = "#F5C06F",
  Yellow = "#F09F17",
  Orange = "#D4843E",
  Darkorange = "#F16529",
  Pink = "#CB6F6F",
  Salmon = "#EE6E73",
  Green = "#8FAA54",
  Lightgreen = "#31B53E",
  White = "#FFFFFF",
  LightBlue = "#5fd7ff",
}

local icons = {
  Brown = { "" },
  Aqua = { "" },
  LightBlue = { "", "" },
  Blue = {
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  },
  Darkblue = { "", "" },
  Purple = { "", "", "", "", "" },
  Red = { "", "", "", "", "", "" },
  Beige = { "", "", "" },
  Yellow = { "", "", "λ", "", "" },
  Orange = { "", "" },
  Darkorange = { "", "", "", "", "" },
  Pink = { "", "" },
  Salmon = { "" },
  Green = { "", "", "", "", "", "" },
  Lightgreen = { "", "", "", "﵂" },
  White = { "", "", "", "", "", "" },
}

local function get_file_info()
  return vim.fn.expand "%:t", vim.fn.expand "%:e"
end

function M.get_file_icon()
  local icon = ""
  if vim.fn.exists "*WebDevIconsGetFileTypeSymbol" == 1 then
    icon = vim.fn.WebDevIconsGetFileTypeSymbol()
    return icon .. " "
  end
  local ok, devicons = pcall(require, "nvim-web-devicons")
  if not ok then
    print "No icon plugin found. Please install 'kyazdani42/nvim-web-devicons'"
    return ""
  end
  local f_name, f_extension = get_file_info()
  icon = devicons.get_icon(f_name, f_extension)
  if icon == nil then
    icon = ""
  end
  return icon .. " "
end

function M.get_file_icon_color()
  local f_name, f_ext = get_file_info()

  local has_devicons, devicons = pcall(require, "nvim-web-devicons")
  if has_devicons then
    local icon, iconhl = devicons.get_icon(f_name, f_ext)
    if icon ~= nil then
      return vim.fn.synIDattr(vim.fn.hlID(iconhl), "fg")
    end
  end

  local icon = M.get_file_icon():match "%S+"
  for k, _ in pairs(icons) do
    if vim.fn.index(icons[k], icon) ~= -1 then
      return icon_colors[k]
    end
  end
end

return M
