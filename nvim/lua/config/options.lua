local opt = vim.opt

opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = tab
opt.autoindent = true

opt.smartcase = true
opt.cursorline = true
opt.number = true

opt.clipboard:append({"unnamedplus"})
