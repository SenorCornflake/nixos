local add_text = "+"
local delete_text = "-"
local change_text = "~"
local changedelete_text = "~"
local topdelete_text = "^"

SetupGitsigns = function()
	require('gitsigns').setup {
		signs = {
			add          = {hl = 'GitSignsAdd'   , text = add_text, numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
			change       = {hl = 'GitSignsChange', text = change_text, numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
			delete       = {hl = 'GitSignsDelete', text = delete_text, numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
			topdelete    = {hl = 'GitSignsDelete', text = topdelete_text, numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
			changedelete = {hl = 'GitSignsChange', text = changedelete_text, numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
		},
		numhl = false,
		linehl = false,
		keymaps = {
			-- Default keymap options
			noremap = true,

			['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
			['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

			['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
			['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
			['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
			['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
			['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
			['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
			['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
			['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',

			-- Text objects
			['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
			['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
		},
		watch_gitdir = {
			interval = 1000,
			follow_files = true
		},
		current_line_blame_opts = {
			delay = 500,
			virt_text_pos = 'eol',
		},
		current_line_blame = true,
		current_line_blame_formatter = " <author>, <author_time:%Y-%m-%d> - <summary>",
		sign_priority = 0,
		update_debounce = 100,
		status_formatter = nil, -- Use default
		word_diff = false,
		diff_opts = {
			internal = true
		}
	}

end

SetupGitsigns()
vim.cmd "autocmd ColorSchemePre * hi clear GitSignsAdd"
vim.cmd "autocmd ColorSchemePre * hi clear GitSignsDelete"
vim.cmd "autocmd ColorSchemePre * hi clear GitSignsChange"
vim.cmd "autocmd ColorScheme * lua SetupGitsigns()"
