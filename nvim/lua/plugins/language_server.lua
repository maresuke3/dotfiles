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
					},
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				-- formatters
				"goimports",
				"prettier",
				"stylua",
				-- linters
				"golangci-lint",
				"eslint",
				"markdownlint",
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		lazy = false,
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			vim.lsp.config("*", { capabilities = capabilities })

			require("mason-lspconfig").setup({
				ensure_installed = {
					"gopls",
					"remark_ls",
					"jsonls",
					"lua_ls",
					"ts_ls",
					"html",
				},
				automatic_enable = true,
			})
		end,
	},
}
