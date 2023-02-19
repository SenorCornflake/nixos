SetupBufferline = function()
	require "bufferline".setup {
		options = {
			numbers = function(opts)
				return string.format("%s", opts.raise(opts.ordinal))
			end,
			close_command = "bdelete! %d",
			right_mouse_command = "bdelete! %d",
			left_mouse_command = "buffer %d",
			middle_mouse_command = nil,
			indicator = {
				icon = "▎",
				style = "icon";
			},
			buffer_close_icon = '',
			modified_icon = '●',
			close_icon = '',
			left_trunc_marker = '',
			right_trunc_marker = '',
			name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
				-- remove extension from markdown files for example
				if buf.name:match('%.md') then
				  return vim.fn.fnamemodify(buf.name, ':t:r')
				end
			end,
			max_name_length = 18,
			max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
			tab_size = 18,
			diagnostics = "nvim_lsp",
			diagnostics_indicator = function(count, level, diagnostics_dict, context)
				return "("..count..")"
			end,
			offsets = {
				{
					filetype = "Outline",
					text = "Symbols Outline",
					text_align = "center"
				},
				{
					filetype = "neo-tree",
					text = "",
					text_align = "center"
				},
				{
					filetype = "packer",
					text = "Plugin Manager",
					text_align = "center"
				}
			},
			show_buffer_icons = true,
			show_buffer_close_icons = true,
			show_close_icon = true,
			show_tab_indicators = true,
			persist_buffer_sort = true,
			separator_style = "thin",
			sort_by = "id"
		}
	}
end

vim.cmd "autocmd VimEnter,ColorScheme * lua SetupBufferline()"
