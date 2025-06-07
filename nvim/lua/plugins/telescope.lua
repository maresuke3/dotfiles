return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable "make" == 1
      end,
    },
    "nvim-tree/nvim-web-devicons",
  },
  config = function(_, opts)
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local fb_actions = telescope.extensions.file_browser.actions

    opts.defaults = opts.defaults or {}

    opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
      wrap_result = true,
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "bottom" },
      sorting_strategy = "ascending",
      winblend = 0,
      mappings = {
        n = {}
      }
    })

    opts.pickers = {
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
      }
    }

    telescope.setup({
      defaults = {
        preview = {
          treesitter = true,
        },

        file_ignore_patterns = {
          "node_modules",
          ".git/",
          "dist/",
          "build/",
          "*.lock",
        },

        layout_config = {
          horizontal = {
            preview_width = 0.6,
          },
          vertical = {
            mirror = false,
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        live_grep = {
          additional_args = function()
            return {"--hidden"}
          end
        },
      },
    })

    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "file_browser")

    -- keymap settings
    local map = vim.keymap.set

    -- base command
    map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
    map("n", "<leader>fg", builtin.live_grep, { desc = "Live Grep" })
    map("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
    --map("n", "<leader>fh", builtin.help_tag, { desc = "Find help" })

    -- git action
    map("n", "<leader>gf", builtin.git_files, { desc = "Git files" })
    map("n", "<leader>gs", builtin.git_status, { desc = "Git status" })
    map("n", "<leader>gb", builtin.git_branches, { desc = "Git branch" })
    map("n", "<leader>gc", builtin.git_commits, { desc = "Git commit" })
    
    -- any other action
    map("n", "<leader>fc", builtin.commands, { desc = "Find commands" })
    map("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })

    -- search current buffer
    map("n", "<leader>/", function()
      builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
      }))
    end, { desc = "Fuzzy search in curren buffer" })

    map("n", "<leader>fa", function()
      builtin.find_files({
        hidden = true,
        no_ignore = true,
        prompt_titles = "All Files",
      })
    end, { desc = "Find all files" })

  end,
}

