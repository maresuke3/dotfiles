return {
  "lewis6991/gitsigns.nvim",
  lazy = true,
  event = { "LspAttach", "BufRead" },
  config = function()

  local gitsigns = require("gitsigns")
  
  gitsigns.setup({
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    signcolumn = true, -- toggle with `:gitsigns toggle_signs`
    numhl = false,    -- toggle with `:gitsigns toggle_numhl`
    linehl = false,   -- toggle with `:gitsigns toggle_linehl`
    word_diff = false, -- toggle with `:gitsigns toggle_word_diff`
    watch_gitdir = {
      follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = true, -- toggle with `:gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%y-%m-%d> - <summary>",
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- use default
    max_file_length = 40000, -- disable if file is longer than this (in lines)
    preview_config = {
      -- options passed to nvim_open_win
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    --yadm = {
    --  enable = false,
    --},
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
  
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
  
      -- Navigation
      map("n", "]c", function()
        if vim.wo.diff then
          return "]c"
        end
        vim.schedule(function()
          gs.next_hunk()
        end)
        return "<Ignore>"
      end, { expr = true })
  
      map("n", "[c", function()
        if vim.wo.diff then
          return "[c"
        end
        vim.schedule(function()
          gs.prev_hunk()
        end)
        return "<Ignore>"
      end, { expr = true })
  
      -- Actions
      map("n", "<leader>hr", gs.reset_buffer)
      map("n", "<leader>hp", gs.preview_hunk)
    end,
  })
  
  vim.cmd("highlight GitSignsCurrentLineBlame guifg=#555555 gui=bold")
  end,
}

--   {
--     "lewis6991/gitsigns.nvim",
--     lazy = true,
--     config = function()
--       require("gitsigns").setup({
--         signs = {
--           add = { text = "┃" },
--           change = { text = "┃" },
--           delete = { text = "_" },
--           topdelete = { text = "‾" },
--           changedelete = { text = "~" },
--           untracked = { text = "┆" },
--         },
--         signs_staged = {
--           add = { text = "┃" },
--           change = { text = "┃" },
--           delete = { text = "_" },
--           topdelete = { text = "‾" },
--           changedelete = { text = "~" },
--           untracked = { text = "┆" },
--         },
--         signs_staged_enable = true,
--         signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
--         numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
--         linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
--         word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
--         watch_gitdir = {
--           follow_files = true,
--         },
--         auto_attach = true,
--         attach_to_untracked = false,
--         current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
--         current_line_blame_opts = {
--           virt_text = true,
--           virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
--           delay = 1000,
--           ignore_whitespace = false,
--           virt_text_priority = 100,
--           use_focus = true,
--         },
--         current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
--         sign_priority = 6,
--         update_debounce = 100,
--         status_formatter = nil, -- Use default
--         max_file_length = 40000, -- Disable if file is longer than this (in lines)
--         preview_config = {
--           -- Options passed to nvim_open_win
--           border = "single",
--           style = "minimal",
--           relative = "cursor",
--           row = 0,
--           col = 1,
--         },
--       })
--     end,
--   },
-- }
