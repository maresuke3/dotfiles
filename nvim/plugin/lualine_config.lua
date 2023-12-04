local status, lualine = pcall(require, 'lualine')
if (not status) then
  print("not installed lualine")
  return
end

local colors = {
  blue = '#80a0ff',
  cyan = '#79dac8',
  black = '#080808',
  white = '#c6c6c6',
  red = '#ff5189',
  violet = '#d183e8',
  grey = '#303030',
  gray = '#44475a',
  lightgray = '#5f6a8e',
  orange = '#ffb86c',
  purple = '#bd93f9',
  yellow = '#f1fa8c',
  green = '#50fa7b',
}

local bubbles_theme = {
  normal = {
    a = { fg = colors.black, bg = colors.violet },
    b = { fg = colors.white, bg = colors.grey },
    c = { fg = colors.black, bg = colors.black },
  },
  insert = {
    a = { fg = colors.black, bg = colors.blue },
  },
  visual = {
    a = { fg = colors.black, bg = colors.cyan },
  },
  replace = {
    a = { fg = colors.black, bg = colors.red },
  },
  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.black, bg = colors.black },
  },
}

--lualine.setup {
--  options = {
--    icons_enabled = true,
--    theme = bubbles_theme,
--    component_separators = { left = '', right = '' },
--    section_separators = { left = '', right = '' },
--    disabled_filetypes = {},
--  },
--  sections = {
--    lualine_a = {
--      { 'mode', separator = { left = '' }, right_padding = 2 },
--    },
--    lualine_b = { 'branch' },
--    lualine_c = {
--      {
--        'filename',
--        file_status = true,
--      },
--      {
--        'path',
--        path = 0
--
--      },
--      fileformat
--    },
--    lualine_x = {
--      {
--        'diagnostic',
--        sources = { 'nvim_diagnostic' },
--        symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
--      },
--      'encoding',
--      'filetype'
--    },
--    lualine_y = { 'progress' },
--    lualine_z = {
--      { 'location', separator = { right = '' }, left_padding = 2 },
--    },
--  },
--  inactive_sections = {
--    lualine_a = {},
--    lualine_b = {},
--    lualine_c = {
--      {
--        'filename',
--        file_status = true,
--      },
--      {
--        'path',
--        path = 1
--      },
--    },
--    lualine_x = { 'location' },
--    lualine_y = {},
--    lualine_z = {},
--  },
--  tabline = {},
--  extensions = { 'fugitive' },
--}

lualine.setup {
  options = {
    icons_enabled = true,
    theme = 'solarized_dark',
    --theme = bubbles_theme,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {
      { 'mode', separator = { left = '' }, right_padding = 2 },
    },
    lualine_b = { 'branch' },
    lualine_c = {
      {
        'filename',
        file_status = true,
      },
      {
        'path',
        path = 0

      },
      fileformat
    },
    lualine_x = {
      {
        'diagnostic',
        sources = {'nvim_diagnostic'},
        symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '},
      },
      'encoding',
      'filetype'
    },
    lualine_y = { 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        file_status = true,
      },
      {
        'path',
        path = 1
      },
    },
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {'fugitive'},
}
