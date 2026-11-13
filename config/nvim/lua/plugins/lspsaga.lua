return {
	{
		"nvimdev/lspsaga.nvim",
		dependencies = {
        'nvim-treesitter/nvim-treesitter', -- optional
        'nvim-tree/nvim-web-devicons',     -- optional
    },
		config = function()
      require('lspsaga').setup({
				definition = {},
				finder = {},
			})

			local keymap = vim.keymap.set
			-- Definition jump
			keymap("n", "gd", ":Lspsaga goto_definition<cr>")
			keymap("n", "gD", ":Lspsaga peek_definition<cr>")
			keymap("n", "td", ":Lspsaga goto_type_definition<cr>")
			keymap("n", "tD", ":Lspsaga peek_type_definition<cr>")

			-- finder
			keymap("n", "gr", ":Lspsaga finder<cr>")

			-- code action
			keymap("n", "ca", ":Lspsaga code_action<cr>")

			-- rename action
			keymap("v", "rn", ":Lspsaga rename<cr>")


			-- hover
			keymap("n", "K", ":Lspsaga hover_doc ++keep<cr>")
    end,
	}
}
