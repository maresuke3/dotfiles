local wezterm = require 'wezterm'

-- initial setting
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'Solarized Dark - Patched'
config.window_background_opacity = 0.91

-- custom config
-- /*'font-fira-code-nerd-font'*/
config.font =
    wezterm.font('font-fira-code-nerd-font', { weight = 'Bold', stretch = 'Normal', style = 'Normal' })
config.font = wezterm.font_with_fallback {
  'Fira Code',
  'DengXian',
}
config.font_size = 20.0
config.adjust_window_size_when_changing_font_size = false

-- ペイン分割のキーマッピング
local act = wezterm.action
config.keys = {
  {
    key = 'd',
    mods = 'ALT',
    action = act.SplitHorizontal {
      domain = 'CurrentPaneDomain'
    }
  },
  {
    key = "d",
    mods = "ALT|SHIFT",
    action = act.SplitVertical {
      domain = "CurrentPaneDomain"
    }
  },
}
-- mac setting
if wezterm.target_triple == 'x86_64-apple-darwin' then
  -- window setting
  config.window_background_opacity = 0.91
  config.window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  }
end

-- windows setting
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.font = wezterm.font_with_fallback {
    'Fira Code',
    'DengXian',
  }
  config.font_size = 20.0
  config.adjust_window_size_when_changing_font_size = false

  config.default_prog = { "wsl.exe", "--distribution", "Ubuntu-20.04", "--exec", "/bin/zsh", "-l" }
end


return config
