local util = require "neovim_configuration.util"
local fwatch = require "fwatch"

local file_location = os.getenv("XDG_DATA_HOME") .. "/neovim_reload"

if not util.file_exists(file_location) then
	local file = io.open(file_location, "w")
	file:write("reload")
	file:close()
end

fwatch.watch(file_location, "lua LOAD_THEME()")
