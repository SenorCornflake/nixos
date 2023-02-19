local lspconfig = require "lspconfig"
local navic = require "nvim-navic"


local util = require "neovim_configuration.util"

local servers = {
	lua_ls = {
		cmd = { "lua-language-server", "-E" },
		settings = {
			Lua = {
				workspace = {
					library = {
						["/usr/share/nvim/runtime/lua"] = true,
						["/usr/share/nvim/runtime/lua/lsp"] = true,
					}
				},
				diagnostics = {
					enable = true,
					globals = {
						-- Neovim
						"vim",
					},
				},
			}
		},
		root_dir = lspconfig.util.root_pattern(".root")
	},
	rust_analyzer = {
		root_dir = lspconfig.util.root_pattern(".root", "Cargo.toml")
	},

	intelephense = {
		root_dir = lspconfig.util.root_pattern(".root"),
		settings = {
			intelephense = {
				format = {
					enable = true
				},
				diagnostics = {
					run = "onType"
				},
				maxMemory = 200
			}
		}
	},

	tsserver = {
		root_dir = lspconfig.util.root_pattern(".root")
	},
	cssls = {
		cmd = { "css-languageserver", "--stdio" },
		root_dir = lspconfig.util.root_pattern(".root")
	},

	html = {
		cmd = { "html-languageserver", "--stdio" },
		root_dir = lspconfig.util.root_pattern(".root"),
		filetypes = {"php", "html"}
	},

	pyright = {
		root_dir = lspconfig.util.root_pattern(".root")
	},

	jsonls = {
		cmd = { "json-languageserver", "--stdio" },
		root_dir = lspconfig.util.root_pattern(".root")
	},

	rnix = {
		cmd = { "rnix-lsp" },
		root_dir = lspconfig.util.root_pattern(".root")
	},

}

-- Print a message when a server starts
for server, config in pairs(servers) do
	config.on_attach = function(client, bufnr)
		print("Started " .. server)

		if client.server_capabilities.documentSymbolProvider then
			print("Navic enabled")
			navic.attach(client, bufnr)
		else
			print("Navic not supported")
		end
	end
  	config.capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

	lspconfig[server].setup(config)
end

-- Lsp signs
vim.fn.sign_define("DiagnosticSignError" , { texthl = "DiagnosticError", text = "" })
vim.fn.sign_define("DiagnosticSignWarn"  , { texthl = "DiagnosticWarn" , text = "" })
vim.fn.sign_define("DiagnosticSignInfo"  , { texthl = "DiagnosticInfo" , text = "" })
vim.fn.sign_define("DiagnosticSignHint"  , { texthl = "DiagnosticHint" , text = "" })

-- Clear lsp highlights before loading the colorscheme so that we can see whether the colorscheme defines it's own lsp highlights
vim.cmd "autocmd ColorSchemePre * highlight clear DiagnosticError"
vim.cmd "autocmd ColorSchemePre * highlight clear DiagnosticWarn"
vim.cmd "autocmd ColorSchemePre * highlight clear DiagnosticInfo"
vim.cmd "autocmd ColorSchemePre * highlight clear DiagnosticHint"

vim.cmd "autocmd ColorSchemePre * highlight clear ScrollbarError"
vim.cmd "autocmd ColorSchemePre * highlight clear ScrollbarWarn"
vim.cmd "autocmd ColorSchemePre * highlight clear ScrollbarInfo"
vim.cmd "autocmd ColorSchemePre * highlight clear ScrollbarHint"
vim.cmd "autocmd ColorSchemePre * highlight clear ScrollbarErrorHandle"
vim.cmd "autocmd ColorSchemePre * highlight clear ScrollbarWarnHandle"
vim.cmd "autocmd ColorSchemePre * highlight clear ScrollbarInfoHandle"
vim.cmd "autocmd ColorSchemePre * highlight clear ScrollbarHintHandle"

SetupLspHighlights = function()
	-- Check if lsp highlights have been set
	local lsp_color_test = util.get_color(
		{
			{"DiagnosticError", "fg"},
			{"DiagnosticWarn", "fg"},
			{"DiagnosticInfo", "fg"},
			{"DiagnosticHint", "fg"}
		},
		{
			cterm = false,
			gui = false
		}
	)

	-- If they haven't, then define our own lsp colors based on other highlights
	if not lsp_color_test.gui and not lsp_color_test.cterm then
		local bg = util.get_color(
			{
				{ "SignColumn", "bg" },
				{ "Normal", "bg" }
			},
			{
				cterm = "0",
				gui = "#000000"
			}
		)
		local cursor = util.get_color(
			{
				{ "CursorLine", "bg" },
			},
			{
				cterm = "0",
				gui = "#000000"
			}
		)
		local error = util.get_color(
			{
				{ "ErrorMsg", "fg" }
			},
			{
				cterm = "0",
				gui = "#000000"
			}
		)
		local warn = util.get_color(
			{
				{ "Constant", "fg" },
				{ "WarningMsg", "fg"  },
				{ "Boolean", "fg" },
				{ "Delimiter", "fg" }
			},
			{
				cterm = "0",
				gui = "#000000"
			}
		)
		local hint = util.get_color(
			{
				{ "Special", "fg" },
				{ "Function", "fg" },
				{ "Include", "fg" }
			},
			{
				cterm = "0",
				gui = "#000000"
			}
		)
		local info = util.get_color(
			{
				{ "String", "fg" },
				{ "DiffAdded", "fg" },
				{ "DiffAdd", "fg" },
			},
			{
				cterm = "0",
				gui = "#000000"
			}
		)
		vim.cmd("highlight DiagnosticError guifg=" .. error.gui .. " guibg=" .. bg.gui .. " ctermfg=" .. error.cterm .. " ctermbg=" .. bg.cterm)
		vim.cmd("highlight DiagnosticWarn  guifg=" .. warn.gui  .. " guibg=" .. bg.gui .. " ctermfg=" .. warn.cterm  .. " ctermbg=" .. bg.cterm)
		vim.cmd("highlight DiagnosticInfo  guifg=" .. info.gui  .. " guibg=" .. bg.gui .. " ctermfg=" .. info.cterm  .. " ctermbg=" .. bg.cterm)
		vim.cmd("highlight DiagnosticHint  guifg=" .. hint.gui  .. " guibg=" .. bg.gui .. " ctermfg=" .. hint.cterm  .. " ctermbg=" .. bg.cterm)
	end
end

SetupLspHighlights()
vim.cmd "autocmd ColorScheme * lua SetupLspHighlights()"

-- Set lsp virtual text style
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = {
			spacing = 4,
			prefix = " "
		}
	}
)
