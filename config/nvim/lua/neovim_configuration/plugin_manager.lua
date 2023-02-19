local install_path = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.cmd("!git clone https://github.com/wbthomason/packer.nvim "..install_path)
end

vim.cmd "packadd packer.nvim"
local packer = require "packer"

packer.init {
	git = {
		clone_timeout = 600
	},
	auto_clean = true,
	compile_on_sync = true,
	profile = {
		enable = true,
		theshold = 1
	}
}

-- Disable some ddefault plugins
local disabled_built_ins = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "gzip",
    "zip",
    "zipPlugin",
    "tar",
    "tarPlugin",
    "getscript",
    "getscriptPlugin",
    "vimball",
    "vimballPlugin",
    "2html_plugin",
    "logipat",
    "rrhelper",
    "spellfile_plugin",
    "matchit"
}

for _, plugin in pairs(disabled_built_ins) do
    vim.g["loaded_" .. plugin] = 1
end

packer.startup(function(use)
	use {
		"wbthomason/packer.nvim",
		opt = true,
	}

	use {
		'projekt0n/github-nvim-theme',
		event = {
			"User load_github_theme",
		},
		cmd = "colorscheme"
	}

	use {
		"Pocco81/Catppuccino.nvim",
		event = {
			"User load_catppuccino_theme",
		},
		cmd = "colorscheme"
	}

	use {
		"bluz71/vim-moonfly-colors",
		event = "User load_moonfly_theme",
	}

	use {
		"bluz71/vim-nightfly-guicolors",
		event = "User load_nightfly_theme"
	}

	use {
		"sainnhe/gruvbox-material",
		event = "User load_gruvbox-material_theme"
	}

	use {
		'kdheepak/monochrome.nvim',
		event = "User load_monochrome_theme"
	}

	use {
		"adisen99/codeschool.nvim",
		event = "User load_codeschool_theme"
	}

	use {
		"RRethy/nvim-base16",
		event = "User load_base16_theme"
	}

	use {
		"marko-cerovac/material.nvim",
		event = "User load_material_theme"
	}

	use {
		"neovim/nvim-lspconfig",
		event = "BufRead",
		config = function()
			require "neovim_configuration.plugins.lspconfig"
		end
	}

	use {
		"hrsh7th/nvim-compe",
		event = "InsertEnter",
		config = function()
			require "neovim_configuration.plugins.compe"
		end
	}

	use {
		"nvim-treesitter/nvim-treesitter",
		event = "BufRead",
		config = function()
			require "neovim_configuration.plugins.treesitter"
		end
	}

	use {
		"voldikss/vim-floaterm",
		cmd = "FloatermNew",
		config = function()
			require "neovim_configuration.plugins.floaterm"
		end
	}

	use {
		'nvim-telescope/telescope.nvim',
		requires = {
			{'nvim-lua/plenary.nvim'}
		},
		cmd = "Telescope",
		config = function()
			require "neovim_configuration.plugins.telescope"
		end
	}

	use {
		"ahmedkhalf/project.nvim",
		config = function()
			require "neovim_configuration.plugins.project"
		end,
		event = "User load_project_plugin",
		keys = "<leader>."
	}

	use {
		'ibhagwan/fzf-lua',
		requires = {
			{
				'vijaymarupudi/nvim-fzf',
				event = "User load_fzf_plugin"
			},
			'kyazdani42/nvim-web-devicons' 
		},
		config = function()
			vim.cmd "doautocmd User load_fzf_plugin"
			require "neovim_configuration.plugins.fzf"
		end,
		cmd = "FzfLua"
	}


	use {
		"dstein64/vim-startuptime",
		cmd = "StartupTime"
	}

	use {
		'akinsho/bufferline.nvim',
		event = "BufRead",
		requires = 'kyazdani42/nvim-web-devicons',
		config = function()
			require "neovim_configuration.plugins.bufferline"
		end
	}

	use {
		"blackCauldron7/surround.nvim",
		event = "BufRead",
		config = function()
			require "neovim_configuration.plugins.surround"
		end
	}

	use {
		'lewis6991/gitsigns.nvim',
		requires = {
		  	'nvim-lua/plenary.nvim'
		},
		event = "BufRead",
		config = function()
			require "neovim_configuration.plugins.gitsigns"
		end
	}

	use {
		"simrat39/symbols-outline.nvim",
		cmd = "SymbolsOutline",
		setup = function()
			require "neovim_configuration.plugins.symbols-outline"
		end
	}

	use {
		'phaazon/hop.nvim',
		cmd = {
			"HopChar1",
			"HopChar2",
			"HopLine",
			"HopWord",
		},
		config = function()
			require "neovim_configuration.plugins.hop"
		end
	}

	use {
		"RRethy/vim-hexokinase",
		run = "make hexokinase",
		ft = {
			"html",
			"css",
			"php",
			"javascript"
		},
		cmd = "HexokinaseToggle",
		config = function()
			require "neovim_configuration.plugins.hexokinase"
		end
	}


	use {
		'onsails/lspkind-nvim',
		event = "InsertEnter",
		config = function()
			require "neovim_configuration.plugins.lspkind"
		end
	}

	use {
		"tpope/vim-fugitive",
		cmd = "Git",
		config = function()
		end
	}

	use {
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require "neovim_configuration.plugins.autopairs"
		end
	}

	use {
		"nvim-lua/plenary.nvim"
	}

	use {
		"b3nj5m1n/kommentary",
		keys = {
			{ "n", "<leader>cc" },
			{ "n", "<leader>c" },
			{ "v", "<leader>c" },
		},
		setup = function()
			vim.g.kommentary_create_default_mappings = false
		end,
		config = function()
			require "neovim_configuration.plugins.kommentary" 
		end	
	}

	use {
		'famiu/feline.nvim',
		event = "VimEnter", -- bufread
		requires = {'kyazdani42/nvim-web-devicons', opt = true},
		config = function()
			require "neovim_configuration.plugins.feline"
		end
	}

	use {
		'sindrets/winshift.nvim',
		cmd = "WinShift"
	}

	-- use {
	-- 	"gelguy/wilder.nvim",
	-- 	config = function()
	-- 		require "neovim_configuration.plugins.wilder"
	-- 	end,
	-- 	keys = {
	-- 		":",
	-- 		"?",
	-- 		"/",
	-- 	}
	-- }

	use {
		"chr4/nginx.vim";
	}

end)
