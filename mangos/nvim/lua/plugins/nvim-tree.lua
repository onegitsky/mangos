return {
  "nvim-tree/nvim-tree.lua",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    local nvimtree = require("nvim-tree")

    -- recommended settings
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    nvimtree.setup({
      view = {
        relativenumber = true,
        float = {
          enable = true,
          quit_on_focus_loss = true,
          open_win_config = function()
            local screen_w = vim.o.columns
            local screen_h = vim.o.lines - vim.o.cmdheight

            local window_w = 55
            local window_h = 40

            local center_col = math.floor((screen_w - window_w) / 2)
            local center_row = math.floor((screen_h - window_h) / 2) - 2

            return {
              relative = "editor",
              border = "rounded",
              width = window_w,
              height = window_h,
              row = center_row,
              col = center_col,
              style = "minimal",
            }
          end,
        },
      },

      renderer = {
        highlight_opened_files = "none",
        indent_markers = {
          enable = true,
        },
        icons = {
          glyphs = {},
        },
      },

      filters = {
        custom = { ".DS_Store" },
      },

      git = {
        ignore = false,
      },
    })

    -- Directory text color
    local function setup_nvimtree_colors()
      local dir_color = "#e17d94"
      vim.api.nvim_set_hl(0, "NvimTreeFolderName",        { fg = dir_color })
      vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName",  { fg = dir_color })
      vim.api.nvim_set_hl(0, "NvimTreeEmptyFolderName",   { fg = dir_color })
      vim.api.nvim_set_hl(0, "NvimTreeSymlinkFolderName", { fg = dir_color })
    end
    setup_nvimtree_colors()

    -- Folder icon colors
    local function setup_nvimtree_icon_colors()
      local folder_icon_color = "#e17d94"
      vim.api.nvim_set_hl(0, "NvimTreeFolderIcon",        { fg = folder_icon_color })
      vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderIcon",  { fg = folder_icon_color })
      vim.api.nvim_set_hl(0, "NvimTreeClosedFolderIcon",  { fg = folder_icon_color })
      vim.api.nvim_set_hl(0, "NvimTreeSymlinkFolderIcon", { fg = folder_icon_color })
    end
    setup_nvimtree_icon_colors()

    -- Re-apply colors when colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        setup_nvimtree_colors()
        setup_nvimtree_icon_colors()
      end,
    })

    -- === Exec File Color (This is what you wanted) ===
    local function setup_exec_color()
      vim.api.nvim_set_hl(0, "NvimTreeExecFile", { fg = "#ad61ce" })  -- Change this color as you like
    end
    setup_exec_color()

    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = setup_exec_color,
    })

    -- Keymaps
    local keymap = vim.keymap
    keymap.set("n", "<leader>n", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
    keymap.set("n", "<leader>a", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
    keymap.set("n", "<leader>c", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
    keymap.set("n", "<leader>r", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
  end,
}
