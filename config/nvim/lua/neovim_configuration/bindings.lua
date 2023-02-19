local util = require "neovim_configuration.util"

vim.g.mapleader = " "

-- Easy normal mode
util.map("i", "kj", "<Esc>", { noremap = true, silent = true })

-- Easy writing
util.map("n", "<leader>w", ":w<CR>")

-- Cycle through popup menu
util.map('i', '<Tab>'  , 'pumvisible() ? "<C-n>" : "<Tab>"'  , { expr = true, noremap = true, silent = true })
util.map('i', '<S-Tab>', 'pumvisible() ? "<C-p>" : "<S-Tab>"', { expr = true, noremap = true, silent = true })

-- Reload theme
util.map("n", "<leader>,", ":lua LOAD_THEME()<cr>")

-- Undo points
util.map("i", ",", ",<c-g>u")
util.map("i", ".", ".<c-g>u")
util.map("i", ";", ";<c-g>u")
util.map("i", "!", "!<c-g>u")
util.map("i", "?", "?<c-g>u")
util.map("i", "=", "=<c-g>u")

-- Black hole deleting
util.map("n", "x", "\"_d")
util.map("n", "xx", "\"_dd")
util.map("n", "X", "\"_D")
util.map("x", "X", "\"_d")
util.map("x", "x", "\"_d")

-- When pasting over visual selection, restore the clipboard as doing this will place the overwritten text into the register
util.map("x", "p", 'p:let @+=@0<CR>:let @"=@0<CR>')

-- Split management
util.map("n", "<C-h>", "<C-w>h")
util.map("n", "<C-j>", "<C-w>j")
util.map("n", "<C-k>", "<C-w>k")
util.map("n", "<C-l>", "<C-w>l")
util.map("n", "<M-w>", "<cmd>WinShift<CR>")

util.map("n", "<M-h>", "<C-w>10<")
util.map("n", "<M-j>", "<C-w>10-")
util.map("n", "<M-k>", "<C-w>10+")
util.map("n", "<M-l>", "<C-w>10>")
util.map("n", "<M-i>", "<C-w>=")

util.map("n", "<leader>q", "<C-w>q")

-- Keep searches centered
util.map("n", "n", "nzzzv")
util.map("n", "N", "Nzzzv")

-- Fuzzy Finder
util.map("n", "<leader>ff", ":Telescope find_files<CR>")
util.map("n", "<leader>fg", ":Telescope live_grep<CR>")
util.map("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>")
util.map("n", "<leader>fS", ":Telescope lsp_workspace_symbols<CR>")
util.map("n", "<leader>fr", ":Telescope lsp_references<CR>")
util.map("n", "<leader>fe", ":Telescope diagnostics bufnr=0<CR>")
util.map("n", "<leader>fE", ":Telescope diagnostics<CR>")
util.map("n", "<leader>fb", ":Telescope buffers<CR>")
util.map("n", "<leader>f/", ":Telescope current_buffer_fuzzy_find<CR>")
util.map("n", "<leader>f.", ":Telescope builtin<CR>")
util.map("n", "<leader>fp", ":Telescope projects<CR>")

-- LSP
util.map('n', '<leader>ld', ':lua vim.lsp.buf.definition()<cr>')
util.map('n', '<leader>lD', ':lua vim.lsp.buf.declaration()<cr>')
util.map('n', '<leader>li', ':lua vim.lsp.buf.implementation()<cr>')
util.map('n', '<leader>ls', ':lua vim.lsp.buf.signature_help()<cr>')
util.map('n', '<leader>lk', ':lua vim.lsp.buf.hover()<cr>')
util.map('n', '<leader>lr', ':lua vim.lsp.buf.rename()<cr>')
util.map('n', '<leader>lR', ':lua vim.lsp.buf.references()<cr>')
util.map('n', '<leader>le', ':lua vim.diagnostic.open_float()<cr>')

-- File manager
util.map("n", "<leader>e", ":Lf<CR>")

-- Hop
util.map("n", "ss", ":HopChar1<CR>")
util.map("n", "sS", ":HopChar2<CR>")
util.map("n", "sl", ":HopLineStart<CR>")
util.map("n", "sL", ":HopLine<CR>")
util.map("n", "sw", ":HopWord<CR>")

util.map("x", "ss", ":HopChar1<CR>")
util.map("x", "sS", ":HopChar2<CR>")
util.map("x", "sl", ":HopLineStart<CR>")
util.map("x", "sL", ":HopLine<CR>")
util.map("x", "sw", ":HopWord<CR>")

-- Buffers
util.map('n', '<leader>bd', ':bd<CR>')
util.map('n', '<leader>bD', ':bd!<CR>')
util.map("n", "<leader>1", ":BufferLineGoToBuffer 1<CR>")
util.map("n", "<leader>2", ":BufferLineGoToBuffer 2<CR>")
util.map("n", "<leader>3", ":BufferLineGoToBuffer 3<CR>")
util.map("n", "<leader>4", ":BufferLineGoToBuffer 4<CR>")
util.map("n", "<leader>5", ":BufferLineGoToBuffer 5<CR>")
util.map("n", "<leader>6", ":BufferLineGoToBuffer 6<CR>")
util.map("n", "<leader>7", ":BufferLineGoToBuffer 7<CR>")
util.map("n", "<leader>8", ":BufferLineGoToBuffer 8<CR>")
util.map("n", "<leader>9", ":BufferLineGoToBuffer 9<CR>")
util.map("n", "<leader>0", ":BufferLineGoToBuffer 10<CR>")

-- Git
util.map("n", "<leader>gc", ":Git commit<CR>")
util.map("n", "<leader>ga", ":Git add ", { noremap = true, silent = false })
util.map("n", "<leader>gp", ":Git push<CR>")
util.map("n", "<leader>gP", ":Git pull<CR>")
util.map("n", "<leader>gb", ":Git blame<CR>")
util.map("n", "<leader>gl", ":Git log<CR>")

-- Symbols outline
util.map("n", "<leader>o", ":SymbolsOutline<CR>")

-- define Project root
util.map("n", "<leader>.", ":ProjectRoot<CR>")

util.map("n", "<leader>t", ":NeoTreeShowToggle<cr>")
util.map("n", "<leader>T", ":NeoTreeClose<cr>")

-- Comments -- Refer to kommentary.lua

-- Visual
util.map("v", ">", ">gv")
util.map("v", "<", "<gv")

-- Dial
util.map("n", "<C-a>", "<Plug>(dial-increment)")
util.map("n", "<C-x>", "<Plug>(dial-decrement)")
util.map("x", "<C-a>", "<Plug>(dial-increment)")
util.map("x", "<C-x>", "<Plug>(dial-decrement)")
util.map("x", "g<C-a>", "<Plug>(dial-increment-additional)")
util.map("x", "g<C-x>", "<Plug>(dial-decrement-additional)")

-- Commands
vim.cmd "command! AdaptSystem lua require('neovim_configuration.util').adapt_system()"
vim.cmd "command! SynStack lua require('neovim_configuration.util').synstack()"
