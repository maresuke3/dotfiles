local status, telescope = pcall(require, 'telescope')
if (not status) then return end

local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
local function extensions(name, prop)
  return function(opt)
    return function()
      telescope.load_extension(name)
      return telescope.extensions[name][prop](opt or {})
    end
  end
end

telescope.setup {
  vim.keymap.set('n', ';ff', function()
    builtin.find_files({
      noignore = false,
      hidden = false,
    })
  end),
  vim.keymap.set('n', ';fg', builtin.live_grep, {}),
  vim.keymap.set('n', ';fb', builtin.buffers, {}),
  vim.keymap.set('n', ';fh', builtin.help_tags, {}),
  --
  vim.keymap.set('n', '<leader>gh', extensions('ghq', 'list') {}),
  vim.keymap.set('n', '<leader>fz', extensions('z', 'list') {}),
}
