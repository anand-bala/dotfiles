local command = vim.api.nvim_create_user_command
local settings = require "_settings"

command("DarkMode", function()
  settings.set_dark_mode()
end, {
  force = true,
})

command("LightMode", function()
  settings.set_light_mode()
end, {
  force = true,
})
