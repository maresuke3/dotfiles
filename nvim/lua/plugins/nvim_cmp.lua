return {
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"onsails/lspkind-nvim",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
		},
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, { name = "emoji" })
		end,
		config = function()
			-- TODO: complession setting
			local cmp = require("cmp")
			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<c-b>"] = cmp.mapping.scroll_docs(-4),
					["<c-f>"] = cmp.mapping.scroll_docs(4),
					["<c-space>"] = cmp.mapping.complete(),
					["<c-e>"] = cmp.mapping.abort(),
					["<cr>"] = cmp.mapping.confirm({ select = false }),
          ["<tab>"] = cmp.mapping.select_next_item(),
          ["<c-k>"] = cmp.mapping.select_prev_item(),
				}),

				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})

			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "nvim_lsp_document_symbol" },
					{
						name = "buffer",
						option = {
							keyword_pattern = [[\k\+]],
						}
					},
				}
			})

			cmp.setup.cmdline({ "." }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "path" },
					{ name = "cmdline" },
				},
				matching = { disallow_symbol_nonprefix_matching = false },
			})
		end,
	}
}
