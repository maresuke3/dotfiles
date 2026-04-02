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
			  -- item field formatters
			formats = {
			  icon = function(item)
			    if item.file and item.icon == "file" or item.icon == "directory" then
		        return M.icon(item.file, item.icon)
		      end
		      return { item.icon, width = 2, hl = "icon" }
			  end,
			  footer = { "%s", align = "center" },
			  header = { "%s", align = "center" },
		    file = function(item, ctx)
		      local fname = vim.fn.fnamemodify(item.file, ":~")
			    fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
			    if #fname > ctx.width then
			      local dir = vim.fn.fnamemodify(fname, ":h")
		        local file = vim.fn.fnamemodify(fname, ":t")
		        if dir and file then
		          file = file:sub(-(ctx.width - #dir - 2))
							fname = dir .. "/…" .. file
			      end
			    end
			    local dir, file = fname:match("^(.*)/(.+)$")
			    return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
		    end,
		  },
			sections = {
  			{ section = "header" },
  			{
          section = "keys",
          gap = 1,
          padding = 1
        },
  		  { section = "startup" },
  		  {
  		    section = "terminal",
  			  --cmd = "pokemon-colorscripts -r --no-title; sleep .1",
          cmd = "pokemon-colorscripts --name mawile",
  			  random = 10,
  		    pane = 2,
  		    indent = 3,
  		    height = 20,
  		  },
  		},
		},
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
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
