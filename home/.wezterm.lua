local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Selenized Dark (Gogh)"
config.font = wezterm.font("DejaVu Sans Mono", {})
config.font_size = 12
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

return config
