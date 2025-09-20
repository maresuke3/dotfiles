local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- tab controller
keymap("n", "<leader>te", ":tabedit<cr>", opts)
keymap("n", "<leader>tn", ":tabnew<cr>", opts)
keymap("n", "<tab>", ":tabnext<cr>", opts)
keymap("n", "<s-tab>", ":tabprevious<cr>", opts)
keymap("n", "<leader>tx", ":tabdelete<cr>", opts)

-- buffer controller
keymap("n", "<leader>bd", ":bdelete<cr>", opts)

-- winbow controller
keymap("n", "<leader>sp", ":split<cr>", opts)
keymap("n", "<leader>vs", ":vsplit<cr>", opts)

-- jump list
keymap("n", "<c-m>", "<c-i>", opts)

-- diagnostics
keymap("n", "<c-j>", function()
	vim.diagnostic.goto_next()
end, opts)
