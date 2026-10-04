-- Prepend lua 5.1 to PATH for Neovim (fixes checkhealth warnings without changing global shell)
local home = os.getenv("HOME")
vim.env.PATH = home .. "/.local/share/mise/installs/lua/5.1.5/bin:" .. home .. "/.local/share/mise/installs/lua/5.1.5/luarocks/bin:" .. vim.env.PATH

require("config.base")
require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.autocmds")
