-- 💡 NOTE: 設定を変更した場合は `Ctrl + Shift + R` で明示的にリロードして反映させること
local wezterm = require("wezterm")

-- initial setting
local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Solarized Dark Higher Contrast (Gogh)"

-- custom config
config.font = wezterm.font_with_fallback({
	"Cica",
	"FiraCode Nerd Font",
	"Fira Code",
	"DengXian",
})
config.adjust_window_size_when_changing_font_size = false

local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
end)

-- ペイン分割のキーマッピング
local act = wezterm.action
config.keys = {
	{
		key = "d",
		mods = "ALT",
		action = act.SplitHorizontal({
			domain = "CurrentPaneDomain",
		}),
	},
	{
		key = "d",
		mods = "ALT|SHIFT",
		action = act.SplitVertical({
			domain = "CurrentPaneDomain",
		}),
	},
	{
		key = "Enter",
		mods = "SHIFT",
		action = wezterm.action({ SendString = "\x1b\r" }),
	},
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = act.PaneSelect({
			alphabet = "1234567890",
		}),
	},
	{
		key = "s",
		mods = "CTRL|SHIFT",
		action = act.PaneSelect({
			mode = "SwapWithActive",
		}),
	},
}

config.enable_kitty_keyboard = false
-- mac setting
if wezterm.target_triple:find("darwin") then
	-- window setting
	config.window_background_opacity = 0.8
	config.window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	}
end

-- windows setting
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	config.font = wezterm.font_with_fallback({
		"Cica",
		"FiraCode Nerd Font",
		"Fira Code",
		"DengXian",
	})
	config.font_size = 14.0
	config.window_background_opacity = 0.8
	config.adjust_window_size_when_changing_font_size = false

	config.default_prog = {
		"wsl",
	}

	table.insert(config.keys, {
		key = "d",
		mods = "CTRL",
		action = act.SplitHorizontal({
			domain = "CurrentPaneDomain",
		}),
	})
	table.insert(config.keys, {
		key = "d",
		mods = "CTRL|SHIFT",
		action = act.SplitVertical({
			domain = "CurrentPaneDomain",
		}),
	})
	table.insert(config.keys, {
		key = "s",
		mods = "CTRL",
		action = act.ShowLauncherArgs({
			flags = "WORKSPACES",
			title = "Select workspace",
		}),
	})
end

config.warn_about_missing_glyphs = false
return config
