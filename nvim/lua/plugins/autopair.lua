return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"windwp/nvim-ts-autotag",
		lazy = "InsertEnter",
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_siash = false,
		}
	}
}
