return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    lazy = false,
    keys = {
      {
        "<leader>fP",
        function()
          local builtin = require("telescope.builtin")
          builtin.find_files({
            cwd = require("lazy.core.config").options.root,
          })
        end,
        desc = "Find Plugins File",
      },
      {
        "<leader>ff",
        function()
          local builtin = require("telescope.builtin")
          builtin.find_files({
            no_ignore = false,
            hidden = true,
          })
        end,
        desc = "Find Files",
      },
      {
        "<leader>fg",
        function()
          require("telescope.builtin").live_grep({
            no_ignore = false,
            hidden = false,
          })
        end,
        desc = "Live Grep files",
      },

      -- buffer
      {
        "<leader>sb",
        function()
          local builtin = require("telescope.builtin")
          builtin.buffers({})
        end,
        desc = "Serch Buffers",
      },

      -- git
      {
        "<leader>gf",
        function()
          require("telescope.builtin").git_files({
            no_ignore = false,
            hidden = true,
          })
        end,
        desc = "Git files",
      },
      {
        "<leader>gc",
        function()
          local builtin = require("telescope.builtin")
          builtin.git_commits({})
        end,
        desc = "Git Commit",
      },
      {
        "<leader>gb",
        function()
          local builtin = require("telescope.builtin")
          builtin.git_branches({})
        end,
      },
      {
        "<leader>gs",
        function()
          local builtin = require("telescope.builtin")
          builtin.git_status({})
        end,
      },

      --
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
      local actions = require("telescope.actions")
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

      opts.pickers = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = {
            preview_cutoff = 9999,
          },
        },
      }

      opts.extensions = {
        file_browser = {
          theme = "dropdown",
          hijack_netrw = true,
          mappings = {
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
      }

      telescope.setup({
        defaults = {
          file_ignore_patterns = {
            "^.git/",
            "^.cache/",
            "^node_modules/",
            "^.yarn/",
            "mock/",
            "lib/",
            "dist",
          },
        },
      })
      telescope.load_extension("fzf")
      telescope.load_extension("file_browser")
    end,
  },
}
