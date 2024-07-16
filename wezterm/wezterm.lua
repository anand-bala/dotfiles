local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "dayfox"
config.font = wezterm.font("JetBrains Mono")
config.font_size = 14.0
config.enable_tab_bar = false

return config
