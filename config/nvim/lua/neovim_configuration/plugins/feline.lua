local util = require "neovim_configuration.util"
local cmd = vim.cmd
local lsp = require('feline.providers.lsp')
local lsp_severity = vim.diagnostic.severity

SetupStatusline = function()
	local components = {
		active = {
			{},
			{},
			{},
		},
		inactive = {
			{},
			{},
			{},
		},
	}

	local al = function(item)
		table.insert(components.active[1], item)
	end
	local am = function(item)
		table.insert(components.active[2], item)
	end
	local ar = function(item)
		table.insert(components.active[3], item)
	end
	local il = function(item)
		table.insert(components.inactive[1], item)
	end
	local im = function(item)
		table.insert(components.inactive[2], item)
	end
	local ir = function(item)
		table.insert(components.inactive[3], item)
	end

	StatuslineColors = {
		bg = util.get_color(
			{
				{ "StatusLine", "bg" },
			}
		),
		alt_bg = util.get_color(
			{
				{ "Normal", "bg" },
			},
			{
				cterm = "none",
				gui = "none"
			}
		),
		fg = util.get_color(
			{
				{ "Normal", "fg" },
			}
		),
		accent = util.get_color(
			{
				{"Tag", "fg"},
			}
		),
		comment = util.get_color(
			{
				{"Comment", "fg"},
			}
		),
	}

	local bg = StatuslineColors.alt_bg.gui
	local statusline_bg = StatuslineColors.bg.gui

	vim.cmd("hi StatuslineModule ctermbg=8 ctermfg=15 guibg=" .. StatuslineColors.bg.gui .. " guifg=" .. StatuslineColors.fg.gui)
	vim.cmd("hi StatuslineModuleAlt ctermbg=0 ctermfg=7 guibg=" .. StatuslineColors.alt_bg.gui .. " guifg=" .. StatuslineColors.comment.gui)
	vim.cmd("hi StatuslineModuleHighlighted ctermbg=8 ctermfg=14 guibg=" .. StatuslineColors.bg.gui .. " guifg=" .. StatuslineColors.accent.gui)

	local buffer_not_empty = function()
		if vim.fn.empty(vim.fn.expand('%:t')) ~= 1 then
			return true
		end
		return false
	end

	local checkwidth = function()
		local squeeze_width  = vim.fn.winwidth(0) / 2
		if squeeze_width > 40 then
			return true
		end
		return false
	end

	al {
		provider = "file_info",
		type = "unique",
		hl = "StatuslineModule",
		colored_icon = false, -- This as true caused problems
		left_sep = {
			str = "  ",
			hl = "StatuslineModule",
		},
		right_sep = {
			str = "  ",
			hl = "StatuslineModule",
		},
	}

	al {
		provider = "git_branch",
		hl = "StatuslineModuleAlt",
		left_sep = {
			str = "   ",
			hl = "StatuslineModuleAlt",
		},
		right_sep = {
			str = " ",
			hl = "StatuslineModuleAlt",
		},
		enabled = checkwidth,
		icon = {
			str = " ",
			hl = "StatuslineModuleAlt",
		}
	}

	al {
		provider = "git_diff_added",
		hl = "StatuslineModuleAlt",
		right_sep = {
			str = " ",
			hl = "StatuslineModuleAlt",
		},
		icon = {
			str = "+",
			hl = "StatuslineModuleAlt",
		},
		enabled = checkwidth
	}

	al {
		provider = "git_diff_changed",
		hl = "StatuslineModuleAlt",
		right_sep = {
			str = " ",
			hl = "StatuslineModuleAlt",
		},
		icon = {
			str = "~",
			hl = "StatuslineModuleAlt",
		},
		enabled = checkwidth
	}

	al {
		provider = "git_diff_removed",
		hl = "StatuslineModuleAlt",
		right_sep = {
			str = " ",
			hl = "StatuslineModuleAlt",
		},
		icon = {
			str = "-",
			hl = "StatuslineModuleAlt",
		},
		enabled = checkwidth
	}

	al {
		enabled = function()
			return vim.b.gitsigns_status_dict ~= nil and checkwidth()
		end,
		provider = function()
			return "  "
		end,
		hl = "StatuslineModuleAlt",
	}

	al {
		provider = function()
			return ""
		end,
		hl = "StatuslineModule",
	}

	ar {
		provider = "lsp_client_names",
		hl = "StatuslineModuleAlt",
		left_sep = {
			str = "  ",
			hl = "StatuslineModuleAlt",
		},
		right_sep = {
			str = " ",
			hl = "StatuslineModuleAlt",
		},
		enabled = checkwidth,
		icon = {
			str = " ",
			hl = "StatuslineModuleAlt"
		}
	}

	ar {
		provider = "diagnostic_hints",
		hl = "StatuslineModuleAlt",
		right_sep = {
			str = " ",
			hl = "StatuslineModuleAlt",
		},
		icon = {
			str = " ",
			hl = "StatuslineModuleAlt",
		},
		enabled = function() return lsp.diagnostics_exist(lsp_severity.HINT) and checkwidth() end,
	}

	ar {
		provider = "diagnostic_errors",
		hl = "StatuslineModuleAlt",
		right_sep = {
			str = " ",
			hl = "StatuslineModuleAlt",
		},
		icon = {
			str = " ",
			hl = "StatuslineModuleAlt",
		},
		enabled = function() return lsp.diagnostics_exist(lsp_severity.ERROR) and checkwidth() end,
	}

	ar {
		provider = "diagnostic_warnings",
		hl = "StatuslineModuleAlt",
		right_sep = {
			str = " ",
			hl = "StatuslineModuleAlt",
		},
		icon = {
			str = " ",
			hl = "StatuslineModuleAlt",
		},
		enabled = function() return lsp.diagnostics_exist(lsp_severity.WARN) and checkwidth() end,
	}

	ar {
		provider = "diagnostic_info",
		hl = "StatuslineModuleAlt",
		right_sep = {
			str = " ",
			hl = "StatuslineModuleAlt",
		},
		icon = {
			str = " ",
			hl = "StatuslineModuleAlt",
		},
		enabled = function() return lsp.diagnostics_exist(lsp_severity.INFO) and checkwidth() end,
	}

	ar {
		enabled = function()
			return #vim.lsp.buf_get_clients() > 0 and checkwidth()
		end,
		provider = function()
			return "  "
		end,
		hl = "StatuslineModuleAlt",
	}
	ar {
		provider = function()
			return vim.bo.fileencoding
		end,
		hl = "StatuslineModuleHighlighted",
		left_sep = {
			str = "  ",
			hl = "StatuslineModuleHighlighted",
		},
		right_sep = {
			str = "  ",
			hl = "StatuslineModuleHighlighted",
		},
		enabled = checkwidth
	}

	ar {
		provider = "position",
		hl = "StatuslineModuleHighlighted",
		right_sep = {
			str = "  ",
			hl = "StatuslineModuleHighlighted",
		},
	}

	ar {
		provider = function()
			return vim.bo.filetype
		end,
		hl = "StatuslineModuleHighlighted",
		right_sep = {
			str = "  ",
			hl = "StatuslineModuleHighlighted",
		},
		enabled = checkwidth
	}

	il {
		provider = "file_info",
		type = "relative-short",
		hl = "StatuslineModule",
		colored_icon = false, -- This as true caused problems
		left_sep = {
			str = "  ",
			hl = "StatuslineModule",
		},
	}

	require "feline".setup {
		components = components,
	}

end

-- Sometimes, after reloading, the highlights just don't work, so reload the bar every few autocommands
SetupStatusline()
cmd "autocmd User ThemeLoaded lua SetupStatusline()"
cmd "autocmd User PostManipulation lua SetupStatusline()"
