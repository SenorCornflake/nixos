-- require "compe".setup {
-- 	enabled = true,
--   	debug = false,
-- 	min_length = 1,
-- 	preselect = 'disabled',
-- 	throttle_time = 1,
-- 	source_timeout = 1,
-- 	incomplete_delay = 1,
-- 	allow_prefix_unmatch = false,
-- 	source = {
-- 		path = true,
-- 		buffer = true,
-- 		nvim_lsp = true,
-- 		treesitter = true,
-- 
-- 		spell = false,
-- 		tags = false,
-- 		snippets_nvim = false,
-- 		calc = false,
-- 		vsnip = false,
-- 	}
-- }

-- TODO: Figure out why the compe highlight goes away after reloading
vim.cmd("hi link CompeDocumentation Normal")

require 'compe'.setup {
	enabled = false,
	autocomplete = true,
	debug = false,
	min_length = 1,
	preselect = 'enable',
	throttle_time = 80,
	source_timeout = 200,
	resolve_timeout = 800,
	incomplete_delay = 400,
	max_abbr_width = 100,
	max_kind_width = 100,
	max_menu_width = 100,
	documentation = {
		border = "rounded",
		winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
		max_width = 120,
		min_width = 60,
		max_height = math.floor(vim.o.lines * 0.3),
		min_height = 1,
	},
	source = {
		path = true,
		buffer = true,
		calc = true,
		nvim_lsp = true,
		nvim_lua = true,
		vsnip = true,
		ultisnips = true,
		luasnip = true,
	},
}
