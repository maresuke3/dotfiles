nnoremap ;ff <cmd>Telescope find_files<cr>
nnoremap ;fg <cmd>Telescope live_grep<cr>
nnoremap ;fb <cmd>Telescope buffers<cr>
nnoremap ;fh <cmd>Telescope help_tags<cr>
nnoremap <M-p> <cmd>lua require('telescope.builtin').find_files( { cwd = vim.fn.expand('%:p:h') })<cr>
nnoremap <M-g> <cmd>lua require('telescope.builtin').live_grep( { cwd = vim.fn.expand('%:p:h') })<cr>
