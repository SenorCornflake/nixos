local util = require "neovim_configuration.util"

local base16_path = os.getenv("XDG_DATA_HOME") .. "/base16.yaml"

vim.cmd "doautocmd ColorSchemePre"

if util.file_exists(base16_path) then
	local base16 = util.parse_base16_file(base16_path)

	for k, v in pairs(base16) do
		if k:find("base") then
			base16[k] = "#" .. v
		end
	end

	if base16.author == "Neovim" then
		print("Using original neovim scheme")
		LOAD_THEME(base16.scheme)
	else
		require('base16-colorscheme').with_config {
			telescope = false,
		}
		require('base16-colorscheme').setup(base16)
		vim.g.colors_name = "base16"

		if base16.scheme == "Generated" then
			local bg = util.get_color({{"Normal", "bg"}}).gui
			local linenr = bg
			local visual = bg
			local cursorline = bg
			local statusline = bg
			local specialkey = bg
			local whichkeyfloat = bg
			local winseparator = bg

			if bg ~= nil and linenr ~= nil and visual ~= nil and os.getenv("TERM") ~= "linux" then -- If running in tty
				if util.color_is_bright(bg, 0.5) then
					print("Adjusting colors for light colorscheme")
					linenr = util.shade_color(linenr, -20)
					specialkey = util.shade_color(specialkey, -20)
					visual = util.shade_color(visual, -15)
					cursorline = util.shade_color(cursorline, -10)
					statusline = util.shade_color(statusline, -15)
					whichkeyfloat = util.shade_color(whichkeyfloat, -15)
					winseparator = util.shade_color(winseparator, -15)
				else
					print("Adjusting colors for dark colorscheme")
					linenr = util.shade_color(linenr, 100)
					specialkey = util.shade_color(specialkey, 60)
					visual = util.shade_color(visual, 50)
					cursorline = util.shade_color(cursorline, 40)
					statusline = util.shade_color(statusline, 30)
					whichkeyfloat = util.shade_color(whichkeyfloat, 30)
					winseparator = util.shade_color(winseparator, 30)
				end

				vim.cmd("hi LineNr guifg=" .. linenr)
				vim.cmd("hi Visual guibg=" .. visual)
				vim.cmd("hi CursorLine guibg=" .. cursorline)
				vim.cmd("hi CursorLineNr guibg=" .. cursorline)
				vim.cmd("hi StatusLine guibg=" .. statusline)
				vim.cmd("hi SpecialKey guibg=" .. specialkey)
				vim.cmd("hi NonText guifg=" .. specialkey)
				vim.cmd("hi WhichKeyFLoat guibg=" .. whichkeyfloat)
				vim.cmd("hi WinSeparator guifg=" .. winseparator)
			end
		end
	end
else
	print(os.getenv("XDG_DATA_HOME") .. "/base16.yaml does not exist, using default theme")
	vim.cmd "colorscheme default"
end

vim.cmd "doautocmd ColorScheme"
