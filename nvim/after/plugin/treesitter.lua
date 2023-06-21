local status, ts = pcall(require, 'nvim-treesitter.configs')
if (not status) then return end

ts.setup {
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
    disable = {},
  },
  ensure_installed = {
    'lua',
    'tsx',
    'go',
    'json',
    'css',
    'sql'
  },
  autotag = {
    enable = true
  }
}
