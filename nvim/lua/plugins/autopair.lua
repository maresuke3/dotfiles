return {
	{
		"windwp/nvim-autopairs",
		--event = {
    --  "InsertEnter",
    --  "BufNewFile",
    --  "BufReadPre"
    --},
    event = "InsertEnter",
		config = function ()
		  require("nvim-autopairs").setup({})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {
			enable_close = true,
			enable_rename = true,
			enable_close_on_slash = false,
		}
	}
}
