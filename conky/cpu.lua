local M = {}

function M.nproc()
  local handle = io.popen("nproc")
  local result = tonumber(handle:read("*a"))
  return result
end

local info = {
  [[${color}${font1} CPU]],
  [[${color1}${font}Clock Speed:   ${alignr} ${color2}${freq_g}GHz]],
  [[${color1}${font}Usage:         ${alignr} ${color2}${cpu cpu0}%]],
  [[${color2}${font}${cpubar cpu0}]],
}

for i=1,M.nproc() do
  table.insert(info, string.format([[${color1}${font}CPU %d: ${alignr}${color2}${cpu %s}%%]], i, "cpu"..tostring(i)))
  table.insert(info, string.format([[${color2}${font}${cpubar %s}]], "cpu"..tostring(i)))
end

M.text = table.concat(info, "\n")

return M

