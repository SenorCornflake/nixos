local g = vim.g
local cmd = vim.cmd

g.floaterm_opener = "edit"
g.floaterm_width = 0.95
g.floaterm_height = 0.85
g.floaterm_borderchars = "─│─│╭╮╯╰"
g.floaterm_title = ""
g.floaterm_rootmarkers = {".root", ".git", "package.json", "Cargo.toml"}
g.floaterm_width = 0.8
g.floaterm_height = 0.95
g.floaterm_position = "center"

cmd "autocmd ColorScheme,VimEnter * hi link FloatermBorder TelescopeBorder"
cmd "hi link FloatermBorder TelescopeBorder"
