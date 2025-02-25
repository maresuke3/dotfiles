-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- local map = LazyVim.safe_keymap_set
local keyset = vim.keymap
local opts = { noremap = true, silent = true }

-- tab
keyset.set("n", "<leader>te", ":tabedit<cr>", opts)
keyset.set("n", "<tab>", ":tabnext<cr>", opts)
keyset.set("n", "<s-tab>", ":tabprevious<cr>", opts)
keyset.set("n", "<leader>to", ":tabnew<cr>", opts)
keyset.set("n", "<leader>tx", ":bdelete<cr>", opts)

-- buffer
keyset.set("n", "<leader>bd", ":bdelete<cr>", opts)

-- window
keyset.set("n", "<leader>sp", ":split<cr>", opts)
keyset.set("n", "<leader>vs", ":vsplit<cr>", opts)

-- jump list
keyset.set("n", "<C-m>", "<C-i>", opts)

-- diagnostic
keyset.set("n", "<C-j>", function()
  vim.diagnotic.goto_next()
end, opts)

--- lspsaga
keyset.set("n", "<C-d>", "<cmd>Lspsaga term_toggle<cr>")
keyset.set("n", "gD", "<cmd>Lspsaga peek_definition<CR>")
keyset.set("n", "ge", function()
  require("lspsaga.diagnostic"):goto_prev({
    severity = vim.diagnostic.severity.ERROR,
  })
end)

-- any
keyset.set("n", "gd", vim.lsp.buf.definition)
