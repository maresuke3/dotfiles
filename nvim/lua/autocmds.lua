print('autocmds.lua')

local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
local augroup = vim.api.nvim_create_augroup-- Create/get autocommand group

-- running when update lua files
autocmd("BufWritePost", {
  pattern = "*.lua",
  command = "source ~/.config/nvim/init.lua"
})

augroup( 'lua', {} )
autocmd('insertenter', {
  group = 'lua',
  callback = function() print( 'insert enter') end
})
