require "nvim-treesitter.configs".setup {
	ensure_installed = {},
	highlight = {
		enable = true,
		-- Keeps old indenting
		disable = {
			"bash"
		},
		additional_vim_regex_highlighting = {
			"bash"
		}
	},
	indent = {
		enable = true
	},
	incremental_selection = {
		enabled = true;
		keymaps = {
		  init_selection = "gnn",
		  node_incremental = "grn",
		  scope_incremental = "grc",
		  node_decremental = "grm",
		},
	},
}
