vim.g.material_style = "deep ocean"

require "material".setup {
	contrast = {
		sidebars = true,
		floating_windows = true,
	},
	contrast_filetypes = {
		"neo-tree"
	}
}

vim.cmd "colorscheme material"
