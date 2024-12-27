return {
  -- fuzy finder
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    lazy = false,
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        ";ff",
        "<cmd>Telescope find_files<cr>",
        desc = "Find Files"
      },
      {
        "<leader>fp",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
      {
        ";fg",
        function()
          require("telescope.builtin").live_grep({
            cwd = require("lazy.core.config").options.root,
          })
        end,
        desc = "Live Grep File",
      },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          files_ignore_patterns = {
            "^node_modules/",
            "mock/",
            "^.git/",
            "lib/",
            "dist/",
            "^.cache/",
          },
        },
      })
    end,
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },
}
