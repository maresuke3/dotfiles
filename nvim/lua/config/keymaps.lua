-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- tab controle
keymap.set("n", "<leader>te", "tabedit<return>", opts)
--keymap.set("n", "<tab>", ":tabnext<Return>", opts)
--keymap.set("n", "<s-tab>", ":tabprev<Return>", opts)
keymap.set("n", "<leader>tx", ":tabdelete<return>", opts)

-- buffer and
keymap.set("n", "nb", "", opts)
keymap.set("n", "<tab>", ":bnext<Return>", opts)
keymap.set("n", "<s-tab>", ":bprevious<Return>", opts)
keymap.set("n", "<leader>bd", ":bdelete<Return>", opts)

-- window
keymap.set("n", "<leader>sp", ":split<Return>", opts)
keymap.set("n", "<leader>vs", ":vsplit<Return>", opts)
-- resize window

-- jump
keymap.set("n", "<C-m>", "<C-i>", opts)

-- diagnostics
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)


-- filer
keymap.set("n", "<leader>e", "<cmd>Neotree<Return>", opts)
