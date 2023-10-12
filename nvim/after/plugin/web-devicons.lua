local status, devicons = pcall(require, 'nvim-web-devicons')
if (not status) then
  print('not installed nvim-web-devicons')
  return
end

devicons.setup {
  override = {
    zsh = {
      icon = '',
      color = '#428850',
      cterm_color = '65',
      name = 'Zsh'
    },
  },
  color_icons = true,
  default = true,
}
