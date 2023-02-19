local util = require "neovim_configuration.util"

vim.o.background = 'dark'

require('vscode').setup({
    -- Enable transparent background
    transparent = util.is_transparent_background(),
    -- Enable italic comment
    italic_comments = true,
})
