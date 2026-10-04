return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enable = true },
		dashboard = {
			enabled = true,
			width = 60,
			row = nil, -- dashboard position. nil for center
			col = nil, -- dashboard position. nil for center
			pane_gap = 4, -- empty columns between vertical panes
			autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
		  -- These settings are used by some built-in sections
			preset = {
			    -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
			    ---@type fun(cmd:string, opts:table)|nil
		    pick = nil,
			    -- Used by the `keys` section to show keymaps.
			    -- Set your custom keymaps here.
			    -- When using a function, the `items` argument are the default keymaps.
			    ---@type snacks.dashboard.Item[]
			  keys = {
			    { icon = " ", key = "f", desc = "Find File", action = "<cmd>Telescope find_files<cr>" },
			    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
			    { icon = " ", key = "g", desc = "Find Text", action = "<cmd>Telescope live_grep<cr>" },
		      { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
		      { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
			    { icon = " ", key = "s", desc = "Restore Session", section = "session" },
			    { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
			    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
			  },
			    -- Used by the `header` section
			--  header = [[
			--███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
			--████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
			--██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
			--██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
			--██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
			--╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
				header = [[
					 /'\_/`\                                       /\ \            /\ \            
					/\      \     __     _ __    __    ____  __  __\ \ \/'\      __\ \/      ____  
					\ \ \__\ \  /'__`\  /\`'__\/'__`\ /',__\/\ \/\ \\ \ , <    /'__`\/      /',__\ 
					 \ \ \_/\ \/\ \L\.\_\ \ \//\  __//\__, `\ \ \_\ \\ \ \\`\ /\  __/      /\__, `\
					  \ \_\\ \_\ \__/.\_\\ \_\\ \____\/\____/\ \____/ \ \_\ \_\ \____\     \/\____/
					   \/_/ \/_/\/__/\/_/ \/_/ \/____/\/___/  \/___/   \/_/\/_/\/____/      \/___/ 
					                                                                               
					                                                                               
					 __  __  ____    _____   __  __  ______                                        
					/\ \/\ \/\  _`\ /\  __`\/\ \/\ \/\__  _\   /'\_/`\                             
					\ \ `\\ \ \ \L\_\ \ \/\ \ \ \ \ \/_/\ \/  /\      \                            
					 \ \ , ` \ \  _\L\ \ \ \ \ \ \ \ \ \ \ \  \ \ \__\ \                           
					  \ \ \`\ \ \ \L\ \ \ \_\ \ \ \_/ \ \_\ \__\ \ \_/\ \                          
					   \ \_\ \_\ \____/\ \_____\ `\___/ /\_____\\ \_\\ \_\                         
					    \/_/\/_/\/___/  \/_____/`\/__/  \/_____/ \/_/ \/_/                         
				]]
			},
			sections = {
  			{
          section = "header",
          enabled = function() return vim.o.columns >= 130 end,
        },
  		  {
  		    section = "terminal",
          cmd = "pokemon-colorscripts --name mawile --no-title; sleep 999999",
  		    pane = 2,
  		    indent = 3,
  		    height = 15,
          enabled = function() return vim.o.columns >= 130 end,
  		  },
  		  {
  		    section = "terminal",
          cmd = "pokemon-colorscripts --name mawile --no-title; sleep 999999",
  		    indent = 3,
  		    height = 15,
          enabled = function() return vim.o.columns < 130 end,
  		  },
  			{
          section = "keys",
          gap = 1,
          padding = 1
        },
  		  { section = "startup" },
  		},
		},
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = false },
    picker = { enabled = false },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
	},
  keys = {
    {
      "<leader>st",
      function ()
        local snack = require("snacks")
        snack.dashboard()
      end,
      desc = "Open Dashboard"
    }
  }
}
