local util = require "neovim_configuration.util"
local config_home = os.getenv("XDG_CONFIG_HOME")
local data_home = os.getenv("XDG_DATA_HOME")

COLORS = {}

LOAD_THEME = function(name)
	-- Reset all highlights
	vim.cmd "hi clear"

	local colorscheme = nil

	-- Use colorscheme provided
	if name then
		colorscheme = name
	-- Otherwise check for colorscheme in file
	else
		colorscheme = io.open(data_home .. "/neovim_colorscheme.txt", "r")

		-- If file doesn't exist, resort to default theme
		if colorscheme == nil then
			colorscheme = "default"
		else
			colorscheme = colorscheme:read()
		end
	end

	-- Check if we have a config file for this colorscheme
	local has_special_config = util.file_exists(config_home .. "/nvim/lua/neovim_configuration/themes/" .. colorscheme .. ".lua")

	-- If we do, use it
	if has_special_config then
		dofile(config_home .. "/nvim/lua/neovim_configuration/themes/" .. colorscheme .. ".lua")
	-- Otherwise just apply the colorscheme
	else
		vim.cmd("colorscheme " .. colorscheme)
	end

	-- Check if we need a transparent background
	if util.is_transparent_background() then
		vim.cmd "hi Normal guibg=none ctermbg=none"
		vim.cmd "hi NormalNC guibg=none ctermbg=none"
		vim.cmd "hi NormalFloat guibg=none ctermbg=none"
	end

	COLORS.bg = util.get_color ({{ "Normal", "bg" }}, { gui = "none", cterm = "none" })
	COLORS.darkbg = {
		gui = util.shade_color(COLORS.bg.gui, -20),
		cterm = COLORS.bg.cterm
	}
	COLORS.darkerbg = {
		gui = util.shade_color(COLORS.bg.gui, -40),
		cterm = COLORS.bg.cterm
	}
	COLORS.lightbg = {
		gui = util.shade_color(COLORS.bg.gui, 20),
		cterm = COLORS.bg.cterm
	}
	COLORS.lighterbg = {
		gui = util.shade_color(COLORS.bg.gui, 40),
		cterm = COLORS.bg.cterm
	}
	COLORS.sign_bg = util.get_color ({{ "SignColumn", "bg" }, { "Normal", "bg" }}, { gui = "none", cterm = "none" })
	COLORS.fg = util.get_color {{ "Normal", "fg" }}
	COLORS.error = util.get_color {{ "ErrorMsg", "fg" }}
	COLORS.warn = util.get_color {{ "Constant", "fg" }, { "WarningMsg", "fg" }, { "Boolean", "fg" }}
	COLORS.hint = util.get_color {{ "Special", "fg" }, { "Function", "fg" }, { "Include", "fg" }}
	COLORS.info = util.get_color {{ "String", "fg" }, { "DiffAdded", "fg" }, { "DiffAdd", "fg" }}
	COLORS.add = util.get_color {{ "GitSignsAdd", "fg" }, { "GitGutterAdd", "fg" }}
	COLORS.delete = util.get_color {{ "GitSignsDelete", "fg" }, { "GitGutterDelete", "fg" }}
	COLORS.change = util.get_color {{ "GitSignsChange", "fg" }, { "GitGutterChange", "fg" }}

	-- Check if theme has lsp support
	local has_lsp_support = util.get_color({{"DiagnosticError", "fg"}}, { cterm = false, gui = false })

	if not has_lsp_support.gui or not has_lsp_support.cterm then
		vim.cmd("highlight DiagnosticSignError guifg=" .. COLORS.error.gui .. " guibg=" .. COLORS.sign_bg.gui .. " ctermfg=" .. COLORS.error.cterm .. " ctermbg=" .. COLORS.sign_bg.cterm)
		vim.cmd("highlight DiagnosticSignWarn  guifg=" .. COLORS.warn.gui  .. " guibg=" .. COLORS.sign_bg.gui .. " ctermfg=" .. COLORS.warn.cterm  .. " ctermbg=" .. COLORS.sign_bg.cterm)
		vim.cmd("highlight DiagnosticSignInfo  guifg=" .. COLORS.info.gui  .. " guibg=" .. COLORS.sign_bg.gui .. " ctermfg=" .. COLORS.info.cterm  .. " ctermbg=" .. COLORS.sign_bg.cterm)
		vim.cmd("highlight DiagnosticSignHint  guifg=" .. COLORS.hint.gui  .. " guibg=" .. COLORS.sign_bg.gui .. " ctermfg=" .. COLORS.hint.cterm  .. " ctermbg=" .. COLORS.sign_bg.cterm)
		vim.cmd("highlight DiagnosticError guifg=" .. COLORS.error.gui .. " guibg=" .. COLORS.bg.gui .. " ctermfg=" .. COLORS.error.cterm .. " ctermbg=" .. COLORS.bg.cterm)
		vim.cmd("highlight DiagnosticWarn  guifg=" .. COLORS.warn.gui  .. " guibg=" .. COLORS.bg.gui .. " ctermfg=" .. COLORS.warn.cterm  .. " ctermbg=" .. COLORS.bg.cterm)
		vim.cmd("highlight DiagnosticInfo  guifg=" .. COLORS.info.gui  .. " guibg=" .. COLORS.bg.gui .. " ctermfg=" .. COLORS.info.cterm  .. " ctermbg=" .. COLORS.bg.cterm)
		vim.cmd("highlight DiagnosticHint  guifg=" .. COLORS.hint.gui  .. " guibg=" .. COLORS.bg.gui .. " ctermfg=" .. COLORS.hint.cterm  .. " ctermbg=" .. COLORS.bg.cterm)
	end

	vim.cmd "doautocmd User ThemeLoaded"
end
LOAD_THEME()
vim.cmd "autocmd VimEnter, ColorScheme * lua LOAD_THEME()"
