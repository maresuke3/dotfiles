local opt = vim.opt

opt.number = true
--opt.relativenumber = true

opt.expandtab = true 
opt.autoindent = true

opt.ignorecase = true
opt.smartcase = true

opt.shiftwidth = 2
opt.tabstop = 2
opt.cursorline = true

opt.clipboard:append({"unnamedplus"})