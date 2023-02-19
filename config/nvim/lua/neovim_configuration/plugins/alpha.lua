 local alpha = require'alpha'
 local dashboard = require'alpha.themes.dashboard'

local arts = {}
arts[1] = {
[[███▄▄▄▄    ▄█  ▀████    ▐████▀  ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄   ]],
[[███▀▀▀██▄ ███    ███▌   ████▀  ███    ███ ███  ▄██▀▀▀███▀▀▀██▄ ]],
[[███   ███ ███▌    ███  ▐███    ███    ███ ███▌ ███   ███   ███ ]],
[[███   ███ ███▌    ▀███▄███▀    ███    ███ ███▌ ███   ███   ███ ]],
[[███   ███ ███▌    ████▀██▄     ███    ███ ███▌ ███   ███   ███ ]],
[[███   ███ ███    ▐███  ▀███    ███    ███ ███  ███   ███   ███ ]],
[[███   ███ ███   ▄███     ███▄  ███    ███ ███  ███   ███   ███ ]],
[[ ▀█   █▀  █▀   ████       ███▄  ▀██████▀  █▀    ▀█   ███   █▀  ]],
}


arts[2] = {
[[NNNNNNNN        NNNNNNNNIIIIIIIIIIXXXXXXX       XXXXXXXVVVVVVVV           VVVVVVVVIIIIIIIIIIMMMMMMMM               MMMMMMMM]],
[[N:::::::N       N::::::NI::::::::IX:::::X       X:::::XV::::::V           V::::::VI::::::::IM:::::::M             M:::::::M]],
[[N::::::::N      N::::::NI::::::::IX:::::X       X:::::XV::::::V           V::::::VI::::::::IM::::::::M           M::::::::M]],
[[N:::::::::N     N::::::NII::::::IIX::::::X     X::::::XV::::::V           V::::::VII::::::IIM:::::::::M         M:::::::::M]],
[[N::::::::::N    N::::::N  I::::I  XXX:::::X   X:::::XXX V:::::V           V:::::V   I::::I  M::::::::::M       M::::::::::M]],
[[N:::::::::::N   N::::::N  I::::I     X:::::X X:::::X     V:::::V         V:::::V    I::::I  M:::::::::::M     M:::::::::::M]],
[[N:::::::N::::N  N::::::N  I::::I      X:::::X:::::X       V:::::V       V:::::V     I::::I  M:::::::M::::M   M::::M:::::::M]],
[[N::::::N N::::N N::::::N  I::::I       X:::::::::X         V:::::V     V:::::V      I::::I  M::::::M M::::M M::::M M::::::M]],
[[N::::::N  N::::N:::::::N  I::::I       X:::::::::X          V:::::V   V:::::V       I::::I  M::::::M  M::::M::::M  M::::::M]],
[[N::::::N   N:::::::::::N  I::::I      X:::::X:::::X          V:::::V V:::::V        I::::I  M::::::M   M:::::::M   M::::::M]],
[[N::::::N    N::::::::::N  I::::I     X:::::X X:::::X          V:::::V:::::V         I::::I  M::::::M    M:::::M    M::::::M]],
[[N::::::N     N:::::::::N  I::::I  XXX:::::X   X:::::XXX        V:::::::::V          I::::I  M::::::M     MMMMM     M::::::M]],
[[N::::::N      N::::::::NII::::::IIX::::::X     X::::::X         V:::::::V         II::::::IIM::::::M               M::::::M]],
[[N::::::N       N:::::::NI::::::::IX:::::X       X:::::X          V:::::V          I::::::::IM::::::M               M::::::M]],
[[N::::::N        N::::::NI::::::::IX:::::X       X:::::X           V:::V           I::::::::IM::::::M               M::::::M]],
[[NNNNNNNN         NNNNNNNIIIIIIIIIIXXXXXXX       XXXXXXX            VVV            IIIIIIIIIIMMMMMMMM               MMMMMMMM]],
}


arts[3] = {
[[                                                                                     .         .           ]],
[[b.             8  8 8888 `8.`8888.      ,8' `8.`888b           ,8'  8 8888          ,8.       ,8.          ]],
[[888o.          8  8 8888  `8.`8888.    ,8'   `8.`888b         ,8'   8 8888         ,888.     ,888.         ]],
[[Y88888o.       8  8 8888   `8.`8888.  ,8'     `8.`888b       ,8'    8 8888        .`8888.   .`8888.        ]],
[[.`Y888888o.    8  8 8888    `8.`8888.,8'       `8.`888b     ,8'     8 8888       ,8.`8888. ,8.`8888.       ]],
[[8o. `Y888888o. 8  8 8888     `8.`88888'         `8.`888b   ,8'      8 8888      ,8'8.`8888,8^8.`8888.      ]],
[[8`Y8o. `Y88888o8  8 8888     .88.`8888.          `8.`888b ,8'       8 8888     ,8' `8.`8888' `8.`8888.     ]],
[[8   `Y8o. `Y8888  8 8888    .8'`8.`8888.          `8.`888b8'        8 8888    ,8'   `8.`88'   `8.`8888.    ]],
[[8      `Y8o. `Y8  8 8888   .8'  `8.`8888.          `8.`888'         8 8888   ,8'     `8.`'     `8.`8888.   ]],
[[8         `Y8o.`  8 8888  .8'    `8.`8888.          `8.`8'          8 8888  ,8'       `8        `8.`8888.  ]],
[[8            `Yo  8 8888 .8'      `8.`8888.          `8.`           8 8888 ,8'         `         `8.`8888. ]],
}


arts[4] = {
[[888b    888 8888888 Y88b   d88P 888     888 8888888 888b     d888]],
[[8888b   888   888    Y88b d88P  888     888   888   8888b   d8888]],
[[88888b  888   888     Y88o88P   888     888   888   88888b.d88888]],
[[888Y88b 888   888      Y888P    Y88b   d88P   888   888Y88888P888]],
[[888 Y88b888   888      d888b     Y88b d88P    888   888 Y888P 888]],
[[888  Y88888   888     d88888b     Y88o88P     888   888  Y8P  888]],
[[888   Y8888   888    d88P Y88b     Y888P      888   888   "   888]],
[[888    Y888 8888888 d88P   Y88b     Y8P     8888888 888       888]],
}


--dashboard.section.header.val = arts[math.random(1, #arts)]
dashboard.section.header.val = arts[1]

 dashboard.section.buttons.val = {
	 dashboard.button( "e", "󰈔  New file" , ":ene <BAR> startinsert <CR>"),
	 dashboard.button( "n", "󰣞  Edit Neovim Config" , ":cd /etc/nixos/config/nvim <BAR> :Telescope find_files<CR>"),
	 dashboard.button( "d", "󰣞  Edit Dotfiles" , ":cd /etc/nixos <BAR> :Telescope find_files<CR>"),
	 dashboard.button( "p", "󱁿  Projects" , ":cd $DOT_ROOT <BAR> :Telescope projects<CR>"),
	 dashboard.button( "q", "󰅖  Quit NVIM" , ":qa<CR>"),
 }
 dashboard.section.footer.val = ""

 dashboard.config.opts.noautocmd = true

 vim.cmd[[autocmd User AlphaReady echo 'ready']]

 alpha.setup(dashboard.config)
