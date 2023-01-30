print('base.lua')

vim.scriptencoding = 'utf-8'
vim.encoding = 'utf-8'
vim.fileencoding = 'utf-8'

-- display setting
vim.opt.number = true
vim.opt.title = true
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2

-- search and command helper
vim.opt.hlsearch = true
vim.opt.wildmenu = true

-- movement assist
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.compatible = false
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.ai = true
vim.opt.si = true
