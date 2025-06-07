local status, neo = pcall(require, 'NeoSolarized')
if not status then
  print('not install neosolarized')
end

neo.setup {
  style = 'dark',
  transparent = true,
  terminal_colors = true,
  enable_italics = true,
  styles = {
    comments = {
      italic = true
    },
    keywords = {
      italic = true
    },
    functions = {
      bold = true
    },
    variables = {},
    string = {
      italic = true
    },
    underline = true,
    undercurl = true,
  },

  on_highlights = function(highlights, colors)

  end
}

vim.cmd[[
  try
    colorscheme NeoSolarized
  catch /^Vim\%((\a\+)\)\=:E18o/
    colorscheme default
    set background=dark
  endtry
]]
