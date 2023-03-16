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

-- Set lsp virtual text style
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = {
			spacing = 4,
			prefix = "  "
		}
	}
)
