-- plugins/ui.lua

-- Rose pine
require("rose-pine").setup({
	variant = "main",
})

-- Set the colorscheme
vim.cmd("colorscheme rose-pine")

-- Statusline configuration (using mini.statusline)
require("mini.statusline").setup()

-- Indentscope configuration
require("mini.indentscope").setup()

-- Configure Barbecue
require("barbecue").setup({
	theme = "rose-pine",
})

-- Spectre
require("spectre").setup()

return {}
