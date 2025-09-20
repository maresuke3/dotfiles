return {
	{
		"akinsho/toggleterm.nvim",
		lazy = false,
		opts = {
			size = 10,
			open_mapping = {
				[[<c-\>]],
			},
		},

		keys = {
			{ [[<c-\>]], ":ToggleTerm<cr>" },
			{ [[<c-d>]], ":ToggleTerm direction=float<cr>" },
			{ [[<c-n>]], ":ToggleTerm direction=tab<cr>" },
		}
	}
}
