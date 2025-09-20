-- NOTE: status line component
local function current_time()
	return os.date("%H:%M")
end

local function total_lines()
	return vim.fn.line("$")
end

local function indent_style()
	if vim.bo.expandtab then
		return vim.bo.shiftwidth
	else
		return vim.bo.tabstop
	end
end

local function lsp_clients()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if next(clients) == nil then
		return "none LSP"
	end

	local client_names = {}
	for _, client in pairs(clients) do
		table.insert(client.names, client.name)
	end

	return table.concat(client_names, ", ")
end

return {
	-- TODO: setting lualine.nvim
	{
		'nvim-lualine/lualine.nvim',
	  dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require("lualine").setup{
				options = {
				  icons_enabled = true,
			    theme = 'material',
		      component_separators = { left = '', right = ''},
					section_separators = { left = '', right = ''},
			    disabled_filetypes = {
						statusline = {},
				    winbar = {},
				  },
		      ignore_focus = {},
		      always_divide_middle = true,
					globalstatus = true,
			    refresh = {
		        statusline = 1000,
						tabline = 1000,
				    winbar = 1000,
		      }
		    },
				sections = {
		      lualine_a = {'mode'},
		      lualine_b = {{'branch',color={fg="#FF9999"}}},
					lualine_c = {
			      {
		          'diff',
							symbols = {added = ' ', modified = ' ', removed = ' '},
				    },
				    {
		          'diagnostics',
		          symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '}
						},
				    {
				      indent_style
		        },
					},
				  lualine_x = {
			      --{todos.get_top_todo, color = {fg="#FFFF99"}},
		        'encoding', 'filetype', {'filename', path=1}},
						lualine_y = {
				    	{total_lines, color={fg="#FF99FF"}},
				        --{yank_register, icon = '📋'},
				    },
				    lualine_z = {
				      {lsp_clients, color={fg="#99FF99", bg="#3c3c6c"}},
			        {current_time, color={fg="#99FFFF", bg="#3c3c6c"}},
			      }
			  },
			  inactive_sections = {
					lualine_a = {},
				  lualine_b = {},
			    lualine_c = {},
		      lualine_x = {},
		      lualine_y = {},
		      lualine_z = {}
				},
				tabline = {},
			  winbar = {},
		    inactive_winbar = {},
		    extensions = {}
			}
		end,
	},
	-- TODO: setting bufferline.nvim
	{
	  "akinsho/bufferline.nvim",
	  event = "VeryLazy",
	  keys = {
	    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle Pin" },
	    { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete Buffers to the Left" },
	    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
	    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
	    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
	    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
	    { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" },
	    { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" },
	  },
		opts = {},
	  config = function(_, opts)
	    require("bufferline").setup(opts)
	    -- Fix bufferline when restoring a session
	    vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
	      callback = function()
	        vim.schedule(function()
	          pcall(nvim_bufferline)
	        end)
	      end,
	    })
	  end,
	}
}

