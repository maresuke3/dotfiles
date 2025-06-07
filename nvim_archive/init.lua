-- language protcol
--os.getenv('PYTHON_ROOT')..'/shims/python3'

-- lua settings
require('base')
require('highlights')
require('autocmds')
require('plugins')
require('keymap')

local has = vim.fn.has
local is_mac = has "macunix"
local is_win = has "win32"

if is_mac then
  require('macos')
end
if is_win then
  require('win64')
end

