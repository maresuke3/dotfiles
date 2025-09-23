return {
  { 
		"mason-org/mason.nvim",
		opts = {},
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✔",
						package_pending = "→",
						package_uninstalled = "✗",
					}
				}
			})
		end,
	},
	{
    "mason-org/mason-lspconfig.nvim",
    opts = {},
		lazy = false,
    dependencies = {
        "mason-org/mason.nvim",
				"neovim/nvim-lspconfig"
  	},
		config = function()
			require("mason-lspconfig").setup{
				ensure_installed = {
					"gopls",
					"intelephense",
					"remark_ls",
					"jsonls",
					"lua_ls",
					"ts_ls",
					"html",
				},
				automatic_enable = {
					exclude = {}
				},

				function(server_name)
					local lspconfig = require("lspconfig")
					lspconfig[server_name].setup({})
				end,
			}
		end,
	}
}
