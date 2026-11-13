return {
	{
		"akinsho/toggleterm.nvim",
		cmd = { "ToggleTerm", "TermExec" },
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
