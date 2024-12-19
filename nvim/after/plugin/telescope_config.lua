local status, telescope = pcall(require, 'telescope')
if (not status) then
  print('telescope not installed')
  return
end

local actions = require('telescope.actions')
local builtin = require("telescope.builtin")

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local fb_actions = require "telescope".extensions.file_browser.actions

telescope.setup {
  defaults = {
    mappings = {
      n = {
        ["q"] = actions.close
      },
    },
    file_ignore_patterns = {
      "^node_modules/",
      "mock/",
      "^.git/",
      "lib/",
      "dist/",
      "^.cache/",
    },
  },
}


-- telescope's keymaps
vim.keymap.set('n', ';ff',
  function()
    builtin.find_files({
      no_ignore = false,
      hidden = true,
    })
  end)
vim.keymap.set('n', ';fg', function()
  builtin.live_grep()
end)
vim.keymap.set('n', ';gi', function()
  builtin.git_files()
end)
vim.keymap.set('n', '\\\\', function()
  builtin.buffers()
end)
vim.keymap.set('n', ';t', function()
  builtin.help_tags()
end)
vim.keymap.set('n', ';;', function()
  builtin.resume()
end)
vim.keymap.set('n', ';e', function()
  builtin.diagnostics()
end)
