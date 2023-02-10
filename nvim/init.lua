-- lua settings
require('base')
require('autocmds')
require('plugins')

local has = vim.fn.has
local is_mac = has "macunix"
local is_win = has "win32"

if is_mac then
  require('operatesystem.macintosh')
end
if is_win then
  require('operatesystem.windows')
end
