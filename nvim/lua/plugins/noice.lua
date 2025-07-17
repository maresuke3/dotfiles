return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
  	"MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
	},

	keys = {
		{ "<leader>sn", "", desc = "+noice"},
    { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
    { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
    { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
    { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
    { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
    { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
	},
	opts = {
	  options = {
	    -- stylua: ignore
	    close_command = function(n) Snacks.bufdelete(n) end,
	    -- stylua: ignore
	    right_mouse_command = function(n) Snacks.bufdelete(n) end,
	    diagnostics = "nvim_lsp",
	    always_show_bufferline = false,
	    diagnostics_indicator = function(_, _, diag)
	      local icons = LazyVim.config.icons.diagnostics
	      local ret = (diag.error and icons.Error .. diag.error .. " " or "")
	        .. (diag.warning and icons.Warn .. diag.warning or "")
	      return vim.trim(ret)
	    end,
	    offsets = {
	      {
	        filetype = "neo-tree",
	        text = "Neo-tree",
	        highlight = "Directory",
	        text_align = "left",
	      },
	      {
	        filetype = "snacks_layout_box",
	      },
	    },
	    ---@param opts bufferline.IconFetcherOpts
	    get_element_icon = function(opts)
	      return LazyVim.config.icons.ft[opts.filetype]
	    end,
	  },
	}
}
