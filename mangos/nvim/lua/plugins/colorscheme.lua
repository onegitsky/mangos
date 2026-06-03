return {
	"catppuccin/nvim",
	name = "catppuccin",
	priority = 1000,
	config = function()
		require("catppuccin").setup({
			transparent_background = true,
			flavour = "macchiato",
			float = {
				transparent = true,
				solid = false,
			},
			custom_highlights = function()
				local palette = require("catppuccin.palettes").get_palette()
				return {
					TelescopeSelection = {
						bg = "#151515", -- Add background for selected item
						fg = "#e17d94",
						bold = true,           -- Optional: make it stand out
					},
				}
			end,
			styles = {
				comments = { "italic" }, -- Enable italic comments
				keywords = {}, -- No bold keywords
			},
			integrations = {
				treesitter_context = true,
			},
		})
local function setup_borders()
  local border_color = "#e17d94"  -- ← Change this to your preferred color

  vim.api.nvim_set_hl(0, "FloatBorder", {
    fg = border_color,
    bg = "NONE",
  })

  vim.api.nvim_set_hl(0, "TelescopeBorder",       { fg = border_color, bg = "NONE" })
  vim.api.nvim_set_hl(0, "TelescopePromptBorder", { fg = border_color, bg = "NONE" })
  vim.api.nvim_set_hl(0, "TelescopeResultsBorder",{ fg = border_color, bg = "NONE" })
  vim.api.nvim_set_hl(0, "TelescopePreviewBorder",{ fg = border_color, bg = "NONE" })
  vim.api.nvim_set_hl(0, "NvimTreeFloatBorder",   { fg = border_color, bg = "NONE" })
end

-- Apply now and on colorscheme changes
setup_borders()
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = setup_borders,
})
		vim.cmd("colorscheme catppuccin")
	end,
}
