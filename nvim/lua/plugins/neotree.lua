return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	config = function()
		filesystem = {
			filtered_items = {
				hide_dotfiles = false,
				hide_gitignore = true,
				hode_hidden = true,
				hide_by_name = {
					"node_modules",
					".git",
					".DS_Store",
					"dist",
				}
			}
		}
	end,
	keys = {
		{
			"<leader>e",
			"<cmd>Neotree<cr>",
		},
	},
}
