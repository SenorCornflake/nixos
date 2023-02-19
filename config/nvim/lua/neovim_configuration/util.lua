local json = require "neovim_configuration.lib.json"
local util = {}

util.is_transparent_background = function()
	local transparent_background = io.open(os.getenv("XDG_DATA_HOME") .. "/neovim_transparent_background.txt", "r")

	if transparent_background ~= nil then
		transparent_background = transparent_background:read()
	end

	if transparent_background == "true" and not vim.g.getting_colors then
		return true
	end

	return false
end

-- Slightly easier map function
util.map = function(mode, left, right, opts) 
	opts = opts or { noremap = true, silent = true }

	vim.api.nvim_set_keymap(mode, left, right, opts)
end

-- Expand home directory
util.expanduser = function(path)
	return path:gsub("~", os.getenv("HOME"))
end

-- Chech if file is directory
util.isdir = function(path)
	local f = io.open(path, "r")
	local ok, err, code = f:read(1)
	f:close()
	return code == 21
end

-- Get both gui and cterm colors of highlight groups ( with fallback support )
util.get_color = function(highlights, fallbacks)
	if not highlights then return end

	local output = {
		gui = "#000000",
		cterm = "0"
	}

	local get = function(name, attr, mode)
		return vim.api.nvim_exec('echo synIDattr(synIDtrans(hlID("' .. name .. '")), "' .. attr .. '#", "' .. mode .. '")', true)
	end

	-- Have seperate loops so that both cterm and gui can fallback to the next highlight on their own
	for _, h in pairs(highlights) do
		local name = h[1]
		local attr = h[2]

		local color = get(name, attr, "gui")

		if color:len() > 0 then
			output.gui = color
			break
		else
			if fallbacks then
				output.gui = fallbacks.gui
			end
		end
	end

	for _, h in pairs(highlights) do
		local name = h[1]
		local attr = h[2]

		local color = get(name, attr, "cterm")

		if color:len() > 0 then
			output.cterm = color
			break
		else
			if fallbacks then
				output.cterm = fallbacks.cterm
			end
		end
	end

	return output
end

-- File exists
util.file_exists = function(path)
	local f = io.open(path, "r")
	return f ~= nil and io.close(f)
end

-- Get the file name from path ( with extension )
util.extract_file_name = function(path)
	return path:match("^.+/(.+)$")
end

-- Split a string into a table
util.split = function(source, delimiters)
	local elements = {}
	local pattern = '([^'..delimiters..']+)'
	string.gsub(source, pattern, function(value) elements[#elements + 1] = value; end);
	return elements
end

-- List the files in a directory
util.scandir = function(directory)
	local cmd = assert(io.popen('ls -A ' .. directory, "r"))
	local output = cmd:read("*all")
	cmd:close()
	return util.split(output, "\n")
end

util.capture = function(cmd, raw)
	local f = assert(io.popen(cmd, 'r'))
	local s = assert(f:read('*a'))
	f:close()
	if raw then return s end
	s = string.gsub(s, '^%s+', '')
	s = string.gsub(s, '%s+$', '')
	s = string.gsub(s, '[\n\r]+', ' ')
	return s
end

util.adapt_system = function()

	-- Load the colorscheme without manipulating the colors
	-- if colorscheme then
	-- 	vim.cmd "augroup! ColorSchemeManipulation"
	-- 	LOAD_THEME(colorscheme)
	-- 	vim.cmd "augroup ColorSchemeManipulation"
	-- 	vim.cmd "autocmd ColorScheme * lua MANIPULATE_COLORSCHEME()"
	-- 	vim.cmd "augroup END"
	-- end

	local base16 = util.base16ify()

	local base16_json = json.encode(base16)
	local base16_yaml = "\n"
	base16_yaml = base16_yaml .. 'scheme: "' .. base16.scheme .. '"\n'
	base16_yaml = base16_yaml .. 'author: "' .. base16.author .. '"\n'
	base16_yaml = base16_yaml .. 'base00: "' .. base16.base00 .. '"\n'
	base16_yaml = base16_yaml .. 'base01: "' .. base16.base01 .. '"\n'
	base16_yaml = base16_yaml .. 'base02: "' .. base16.base02 .. '"\n'
	base16_yaml = base16_yaml .. 'base03: "' .. base16.base03 .. '"\n'
	base16_yaml = base16_yaml .. 'base04: "' .. base16.base04 .. '"\n'
	base16_yaml = base16_yaml .. 'base05: "' .. base16.base05 .. '"\n'
	base16_yaml = base16_yaml .. 'base06: "' .. base16.base05 .. '"\n'
	base16_yaml = base16_yaml .. 'base07: "' .. base16.base07 .. '"\n'
	base16_yaml = base16_yaml .. 'base08: "' .. base16.base08 .. '"\n'
	base16_yaml = base16_yaml .. 'base09: "' .. base16.base09 .. '"\n'
	base16_yaml = base16_yaml .. 'base0A: "' .. base16.base0A .. '"\n'
	base16_yaml = base16_yaml .. 'base0B: "' .. base16.base0B .. '"\n'
	base16_yaml = base16_yaml .. 'base0C: "' .. base16.base0C .. '"\n'
	base16_yaml = base16_yaml .. 'base0D: "' .. base16.base0D .. '"\n'
	base16_yaml = base16_yaml .. 'base0E: "' .. base16.base0E .. '"\n'
	base16_yaml = base16_yaml .. 'base0F: "' .. base16.base0F .. '"\n'

	-- Not manually closing the file made it only write when neovim closed
	local file = io.open(os.getenv("XDG_DATA_HOME") .. "/base16.json", "w+")
	file:write(base16_json)
	file:close()

	file = io.open(os.getenv("XDG_DATA_HOME") .. "/base16.yaml", "w+")
	file:write(base16_yaml)
	file:close()

	-- TODO: Close the terminal when finished
	vim.cmd ":vsplit | terminal sh apply_theme && exit"
end

-- Generate a base16 theme using highlights from the current theme
util.base16ify = function()
	vim.g.getting_colors = true;

	-- Reload theme without it getting adjusted due to above variable
	LOAD_THEME(vim.g.colors_name)

	local theme = {
		scheme = vim.g.colors_name,
		author = "Neovim",
		base00 = util.get_color {{"Normal", "bg"}},
		base01 = util.get_color {{"CursorLine" , "bg"}},
		base02 = util.get_color {{"Visual", "bg"}, {"Normal", "bg"}},
		base03 = util.get_color {{"Comment", "fg"}},
		base04 = util.get_color {{"StatusLine", "fg"}},
		base05 = util.get_color {{"Normal", "fg"}},
		base06 = util.get_color {{"StatusLine", "fg"}},
		base07 = util.get_color {{"Normal", "fg"}},
		base08 = util.get_color {{"Character", "fg"}, {"String", "fg"}},
		base09 = util.get_color {{"Number", "fg"}, {"Conditional", "fg"}},
		base0A = util.get_color {{"Type", "fg"}},
		base0B = util.get_color {{"String", "fg"}},
		base0C = util.get_color {{"Special", "fg"}},
		base0D = util.get_color {{"Function", "fg"}},
		base0E = util.get_color {{"Conditional", "fg"}},
		base0F = util.get_color {{"Constant", "fg"}, {"Function", "fg"}},
	}

	for k, v in pairs(theme) do
		if k:find("base") then
			theme[k] = v.gui:gsub("#", "")
		end
	end

	-- Re-adjust theme and apply it
	vim.g.getting_colors = false
	LOAD_THEME(vim.g.colors_name)

	return theme
end

-- Print the name of the highlight group under the cursor
util.synstack = function()
	for _, i1 in ipairs(vim.fn.synstack(vim.fn.line('.'), vim.fn.col('.'))) do
		local i2 = vim.fn.synIDtrans(i1)
		local n1 = vim.fn.synIDattr(i1, 'name')
		local n2 = vim.fn.synIDattr(i2, 'name')
		print(n1, '->', n2)
	end
end

-- Return a list of colorschemes
util.colorschemes = function(display)
	display = display or false

	local rtps = vim.o.runtimepath
	rtps = util.split(rtps, ",")

	local colorschemes = {}

	for _, rtp in pairs(rtps) do
		local colors_dir = rtp .. "/colors"

		if vim.fn.isdirectory(colors_dir) then
			for _, colorscheme in pairs(util.split(vim.fn.glob(colors_dir .. "/*.vim"), "\n")) do
				colorscheme = vim.fn.fnamemodify(colorscheme, ":t:r")
				table.insert(colorschemes, colorscheme)
			end
		end
	end

	-- Remove duplicates
	local hash = {}
	local res = {}

	for _,v in pairs(colorschemes) do
	   if not hash[v] then
		   res[#res + 1] = v
		   hash[v] = true
	   end
	end

	colorschemes = res

	if display then
		for _, colorscheme in pairs(colorschemes) do
			print(colorscheme .. "\n")
		end
	else
		return colorschemes
	end
end

-- Color manipulation, found it in bufferlines source
---Convert a hex color to rgb
util.hex_to_rgb = function(color)
  local hex = color:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5), 16)
end

---@source https://stackoverflow.com/q/5560248
---@see: https://stackoverflow.com/a/37797380
---Darken a specified hex color
util.shade_color = function(color, percent)
	local alter = function(attr, percent)
		return math.floor(attr * (100 + percent) / 100)
	end

	local r, g, b = util.hex_to_rgb(color)
		if not r or not g or not b then
	return "NONE"
	end
	r, g, b = alter(r, percent), alter(g, percent), alter(b, percent)
	r, g, b = math.min(r, 255), math.min(g, 255), math.min(b, 255)
	return string.format("#%02x%02x%02x", r, g, b)
end

--- Determine whether to use black or white text
--- References:
--- 1. https://stackoverflow.com/a/1855903/837964
--- 2. https://stackoverflow.com/a/596243
util.color_is_bright = function(hex, control)
	control = control or 0.5
	if not hex then
		return false
	end
	local r, g, b = util.hex_to_rgb(hex)
	-- If any of the colors are missing return false
	if not r or not g or not b then
		return false
	end
	-- Counting the perceptive luminance - human eye favors green color
	local luminance = (0.299 * r + 0.587 * g + 0.114 * b) / 255
	return luminance > control -- if > 0.5 Bright colors, black font, otherwise Dark colors, white font
end

util.parse_base16_file = function(path)
	local text = io.open(path, "r"):read("a*")
	text = util.split(text, "\n")

	for i, line in pairs(text) do
		line = line:gsub('"', ""):gsub(" ", "")

		if line == "" then
			table.remove(text, i)
		else
			line = util.split(line, ":")
			text[i] = line
		end
	end

	local base16 = {}

	for _, line in pairs(text) do
		base16[line[1]] = line[2]
	end

	return base16
end

return util
