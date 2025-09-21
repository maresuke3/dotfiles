-- component
-- clock
local function curren_time()
  return os.date("%H:%M")
end

local function total_lines()
  return vim.fn.line("$")
end

-- lsp_checker
local function lsp_clients()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if next(clients) == nil then
    return "none LSP"
  end
  
  local client_names = {}
  for _, client in pairs(clients) do
    table.insert(client_names, client.name)
  end

  return table.concat(client_name, ",")
end

-- style checker
local function indent_style()
  if vim.bo.expadtab then
    return vim.bo.shiftwidth .. "space"
  else
    return vim.bo.tabstop .. "tab"
  end
end

-- create component
local function yank_register()
  local yank_content = vim.fn.getreg('"')

  if #yank_content > 10 then
    yank_content = string.sub(yank_content, 1, 7) .. "..."
  end

  return yank_content ~= "" and yank_content or "EMPTY"
end

return {
  -- status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "material",
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
          lualine_b = {'branch'},
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
            'encoding', 'filetype', {'filename', path=1}},
          lualine_y = {
            {total_lines, color={fg="#FF99FF"}},
            {yank_register, icon = '📋', color={fg="#FF99FF"}},
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
        winbar ={},
        inactive_winbar = {},
        extensions = {}
      })
    end,
    event = "VeryLazy",
  }
}
