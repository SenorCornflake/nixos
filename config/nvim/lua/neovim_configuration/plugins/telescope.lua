local actions = require "telescope.actions"

require "telescope".setup {
	defaults = {
		layout_config = {
			horizontal = {
				width = 0.79,
				height = 0.93
			}
		},
		mappings = {
			i = {
				["<esc>"] = actions.close,
				[":q<CR>"] = actions.close,
				["<M-q>"] = actions.close
			},
			n = {
				[":q<CR>"] = actions.close,
				["<M-q>"] = actions.close
			}
		}
	},
	pickers = {
		find_files = {
			-- hidden = true,
			-- follow = true,
			find_command = {"rg", "--files", "--hidden", "--follow", "--no-ignore", "-g", "!{.git,node_modules,target}/*"}
		},
		live_grep = {
			vimgrep_arguments = {"rg", "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--hidden", "--no-ignore", "-g", "!{.git,node_modules,target}/*"}
		}
	},
}

require "telescope".load_extension("projects")
