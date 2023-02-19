local util = require "neovim_configuration.util"

local cl = require "kommentary.config".configure_language

cl("default", {
	use_consistent_indentation = true,
	ignore_whitespace = true,
	single_line_comment_string = 'auto',
	multi_line_comment_strings = 'auto',
})

cl("lua", {
	prefer_single_line_comments = true
})

util.map("n", "<leader>cc", "<Plug>kommentary_line_default", {})
util.map("n", "<leader>c", "<Plug>kommentary_motion_default", {})
util.map("v", "<leader>c", "<Plug>kommentary_visual_default", {})
