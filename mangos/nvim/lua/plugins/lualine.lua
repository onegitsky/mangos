return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local lualine = require("lualine")

		local colors = {
      color0 = "#101010",
      color1 = "#dc322f",
      color2 = "#c9d36a",
			color3 = "#AA00",
			color6 = "#f1f59f",
			color7 = "#c0c8d8",
			color8 = "#db9fe9",
		}

		local my_lualine_theme = {
			replace = {
				a = { fg = colors.color0, bg = colors.color1, gui = "bold" },
				b = { fg = colors.color2, bg = colors.color3 },
			},
			inactive = {
				a = { fg = colors.color6, bg = colors.color3, gui = "bold" },
				b = { fg = colors.color6, bg = colors.color3 },
				c = { fg = colors.color6, bg = colors.color3 },
			},
			normal = {
				a = { fg = colors.color0, bg = colors.color7, gui = "bold" },
				b = { fg = colors.color7, bg = colors.color3 },
				c = { fg = colors.color7, bg = colors.color3 },
			},
			visual = {
				a = { fg = colors.color0, bg = colors.color8, gui = "bold" },
				b = { fg = colors.color7, bg = colors.color3 },
			},
			insert = {
				a = { fg = colors.color0, bg = colors.color2, gui = "bold" },
				b = { fg = colors.color7, bg = colors.color3 },
			},
		}

        local mode = {
            'mode',
            fmt = function(str)
                return '- ' .. str .. ' -'
            end,
        }

        local diff = {
            'diff',
            colored = true,
            symbols = { added = ' ', modified = ' ', removed = ' ' }, -- changes diff symbols
            -- cond = hide_in_width,
        }

        local filename = {
            file_status = true,
            path = 0,
        }

        local branch = {
						'branch',
						icon = '',
				}

				local diagnostics = {
					"diagnostics",
					sources = { "nvim_diagnostic" },
					sections = { "error", "warn" },
					symbols = { error = " ", warn = " " },
					colored = true,
					update_in_insert = false,
					always_visible = true,
					cond = function()
						return vim.bo.filetype ~= "markdown"
					end,
				}

				local progress = function()
						local current_line = vim.fn.line(".")
						local total_lines = vim.fn.line("$")
						local chars = { "", "", "" } --adding more chars will still work
						local line_ratio = current_line / total_lines
						local index = math.ceil(line_ratio * #chars)
						return chars[index] .. " " .. math.floor(line_ratio * 100) .. "%%"
					end

		lualine.setup({
			options = {
								icons_enabled = true,
								theme = my_lualine_theme,
								component_separators = { left = "", right = "" },
								section_separators = { left = "", right = "" },
								disabled_filetypes = { "alpha", "dashboard" },
								always_divide_middle = true,
			},
			sections = {
                lualine_a = { mode },
                lualine_b = { branch },
                lualine_c = { diagnostics },
								lualine_x = { diff, "filetype" },
								lualine_y = { "location" },
								lualine_z = { progress }
			},
		})
	end,
}
