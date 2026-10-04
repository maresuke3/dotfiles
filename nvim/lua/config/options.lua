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

opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

opt.foldenable = false

-- Reduce updatetime to trigger CursorHold faster (default is 4000ms)
opt.updatetime = 300

-- Disable unused providers to suppress checkhealth warnings
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

