return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	dependencies = { "RchrdAriza/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
    local stats = require("lazy").stats()
		local dashboard = require("alpha.themes.dashboard")
		local time = os.date("%I:%M%p")
		local date = os.date("%A, %d %b")
		local v = vim.version()
		local version = " " .. v.major .. "." .. v.minor .. "." .. v.patch

		-- Set header
		dashboard.section.header.val = {
"                                                                     ",
"       ████ ██████           █████      ██                     ",
"      ███████████             █████                             ",
"      █████████ ███████████████████ ███   ███████████   ",
"     █████████  ███    █████████████ █████ ██████████████   ",
"    █████████ ██████████ █████████ █████ █████ ████ █████   ",
"  ███████████ ███    ███ █████████ █████ █████ ████ █████  ",
" ██████  █████████████████████ ████ █████ █████ ████ ██████ ",
}

		dashboard.section.buttons.val = {
			dashboard.button("n", "   New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "󰈞   Find file", ":cd $HOME | Telescope find_files<CR>"),
			dashboard.button("r", "󰈢   Recent", ":Telescope oldfiles<CR>"),
			dashboard.button("R", "󱘞   Ripgrep", ":Telescope live_grep<CR>"),
			dashboard.button("p", "󰈮   Projects", ":cd ~/.local/bin | NvimTreeFindFileToggle<CR>"),
			dashboard.button("c", "   Configuration", ":cd ~/.config/nvim | NvimTreeFindFileToggle<CR>"),
			dashboard.button("l", "   Plugin Manager", ":Lazy<CR>"),
			dashboard.button("q", "󰗼   Quit", ":qa<CR>"),
		}

		function centerText(text, width)
			local totalPadding = width - #text
			local leftPadding = math.floor(totalPadding / 2)
			local rightPadding = totalPadding - leftPadding
			return string.rep(" ", leftPadding) .. text .. string.rep(" ", rightPadding)
		end

		dashboard.section.footer.val = {
      centerText("󰂖 ".. stats.loaded .. "/" .. stats.count .. " Plugins Loaded", 52.5),
      centerText(version, 50),
			" ",
			centerText(date .. " / " .. time, 48),
		}

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
