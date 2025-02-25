return {
  -- fuzy finder
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = {
      {
        "<leader>fP",
        function()
          require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root })
        end,
        desc = "Find Plugin File",
      },
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep()
        end,
        desc = "Live Grep File",
      },
      {
        "<leader>sb",
        function()
          require("telescope.builtin").buffers()
        end,
        desc = "Switch Buffer",
      },
      {
        "<leader>gf",
        function()
          require("telescope.builtin").git_files()
        end,
        desc = "Git Files",
      },
      {
        "<leader>gs",
        function()
          local telescope = require("telescope.builtin")
          telescope.git_status({})
        end,
        desc = "Git Status",
      },
      {
        "<leader>gc",
        function()
          require("telescope.builtin").git_commits()
        end,
        desc = "Git Commits",
      },
      {
        "<leader>gb",
        function()
          require("telescope.builtin").git_branches()
        end,
        desc = "Git Branches",
      },
      {
        "<leader>sf",
        function()
          local telescope = require("telescope")
          local function telescope_buffer_dir()
            return vim.fn.expand("%:p:h")
          end

          telescope.extensions.file_browser.file_browser({
            path = "%:p:h",
            cwd = telescope_buffer_dir(),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            initial_mode = "normal",
            layout_config = { height = 40 },
          })
        end,
      },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      local actions = require("telescope.builtin")
      local fb_actions = require("telescope").extensions.file_browser.actions

      opts.defaults = opts.defaults or {}

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
        wrap_results = true,
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "bottom" },
        sorting_strategy = "ascending",
        winblend = 0,
        mappings = {
          n = {},
        },
      })

      opts.pikers = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = { preview_cutoff = 9999 },
        },
      }

      opts.extensions = {
        file_browser = {
          theme = "dropdown",
          hijack_netrw = true,
          mappings = {
            n = {
              ["n"] = {
                ["N"] = fb_actions.create,
                ["h"] = fb_actions.goto_parent_dir,
                ["/"] = function()
                  vim.cmd("startinsert")
                end,
                ["<C-u>"] = function(prompt_bufr)
                  for i = 1, 10 do
                    actions.move_selection_previous(prompt_bufr)
                  end
                end,
                ["<C-d>"] = function(prompt_bufr)
                  for i = 1, 10 do
                    actions.move_selection_next(prompt_bufr)
                  end
                end,
              },
            },
          },
        },
      }

      telescope.setup({
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
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
    end,
  },
}
