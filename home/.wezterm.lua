local wezterm = require("wezterm")
local config = wezterm.config_builder()

local colors = wezterm.get_builtin_color_schemes()["Selenized Dark (Gogh)"]
colors.brights[1] = "#445566"

config.colors = colors
config.font = wezterm.font("DejaVu Sans Mono", {})
config.font_size = 12
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.keys = {
	{
		key = "1",
		mods = "CMD|CTRL",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "2",
		mods = "CMD|CTRL",
		action = wezterm.action.DisableDefaultAssignment,
	},
}

return config
