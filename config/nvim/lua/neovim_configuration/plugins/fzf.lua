local actions = require "fzf-lua.actions"

require "fzf-lua".setup {
	winopts = {
		width = 0.79,
		height = 0.89,
		row = 0.30,
		col = 0.50,
		border       = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
		hl = {
			border = "TelescopeBorder",
		},
	},

	grep = {
		prompt            = 'Rg> ',
		input_prompt      = 'Grep For>',
		multiprocess      = true,           -- run command in a separate process
		git_icons         = true,           -- show git icons?
		file_icons        = true,           -- show file icons?
		color_icons       = true,           -- colorize file|git icons
		-- executed command priority is 'cmd' (if exists)
		-- otherwise auto-detect prioritizes `rg` over `grep`
		-- default options are controlled by 'rg|grep_opts'
		-- cmd            = "rg --vimgrep",
		rg_opts           = "--column --line-number --no-heading --color=always --smart-case --max-columns=512 -g '!{.git,node_modules,target}/*'",
		grep_opts         = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp",
		-- 'live_grep_glob' options:
		glob_flag         = "--iglob",  -- for case sensitive globs use '--glob'
		glob_separator    = "%s%-%-"    -- query separator pattern (lua): ' --'
	},
}

vim.cmd "autocmd FileType fzf tnoremap <silent> <buffer> <M-q> <C-\\><C-n>:q<CR>"
