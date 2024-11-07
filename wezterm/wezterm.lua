local wezterm = require "wezterm"

local config = wezterm.config_builder()

config.color_scheme = "dayfox"
config.font = wezterm.font "JetBrains Mono"
config.font_size = 14.0
config.enable_tab_bar = false

-- Override SSH_AUTH_SOCK to use 1password's ssh agent, if it exists
do
  local onep_auth = string.format("%s/.1password/agent.sock", wezterm.home_dir)
  -- Glob is being used here as an indirect way to check to see if
  -- the socket exists or not. If it didn't, the length of the result
  -- would be 0
  if #wezterm.glob(onep_auth) == 1 then
    config.default_ssh_auth_sock = onep_auth
  end
end

return config
