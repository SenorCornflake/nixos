local util = require "neovim_configuration.util"
local cmd = vim.cmd

MANIPULATE_COLORSCHEME = function()
	local transparent_background = io.open(os.getenv("XDG_DATA_HOME") .. "/neovim_transparent_background.txt", "r")

	if transparent_background == nil then
		transparent_background = "false"
	else
		transparent_background = transparent_background:read()
	end

	if transparent_background == "true" and not vim.g.getting_colors then
		vim.cmd "hi Normal guibg=none ctermbg=none"
		vim.cmd "hi NormalNC guibg=none ctermbg=none"
		vim.cmd "hi NormalFloat guibg=none ctermbg=none"
	end

	vim.cmd "doautocmd User PostManipulation"
end

-- All the doautocmds here are from before I used nix, it was for lazy loading, I don't lazy load anymore because of some issues I had but I think I'll leave these doautocmds here for future reference
LOAD_THEME = function(name)
	-- Clear all highlights so that no remnants of the previous colorscheme remains ( We already do this for gitsigns and lsp diagnostics independantly in their respective config files,
	-- this is just to affirm that in the rare cases where a highlight would remain that it doesn't happen )
	vim.cmd "hi clear"

	local colorscheme = nil

	if name then
		colorscheme = name
	else
		colorscheme = io.open(os.getenv("XDG_DATA_HOME") .. "/neovim_colorscheme.txt", "r")

		if colorscheme == nil then
			colorscheme = "default"
		else
			colorscheme = colorscheme:read()
		end
	end

	local config_dir = os.getenv("XDG_CONFIG_HOME")
	local has_theme = util.file_exists(config_dir .. "/nvim/lua/neovim_configuration/themes/" .. colorscheme .. ".lua")

	if not has_theme then
		cmd ("doautocmd User load_" .. colorscheme .. "_theme")
		cmd ("colorscheme " .. colorscheme)
	else
		if colorscheme == "default" then
			cmd "colorscheme default"
			return
		end

		cmd ("doautocmd User load_" .. colorscheme .. "_theme")
		dofile(os.getenv("XDG_CONFIG_HOME") .. "/nvim/lua/neovim_configuration/themes/" .. colorscheme .. ".lua")
		--require("neovim_configuration.themes." .. colorscheme)
	end

	MANIPULATE_COLORSCHEME()

	cmd "doautocmd User ThemeLoaded"
end

LOAD_THEME()

cmd "autocmd VimEnter, ColorScheme * lua LOAD_THEME()"
cmd "autocmd ColorScheme * lua MANIPULATE_COLORSCHEME()"
