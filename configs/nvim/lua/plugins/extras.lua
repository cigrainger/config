-- plugins/extras.lua

-- Configure Oil
require("oil").setup()

-- Configure mini.bracketed
require("mini.bracketed").setup()

-- Configure Obsidian
require("obsidian").setup({
	finder = "telescope.nvim",
	workspaces = {
		{
			name = "obsidian_vault",
			path = "~/code/obsidian_vault",
		},
	},
	completion = { nvim_cmp = true },
})

-- Configure Neotest
require("neotest").setup({
	adapters = {
		require("neotest-elixir"),
		require("neotest-rust"),
	},
})

-- Configure Trouble
require("trouble").setup({
	modes = {
		test = {
			mode = "diagnostics",
			preview = {
				type = "split",
				relative = "win",
				position = "right",
				size = 0.3,
			},
		},
		symbols = {
			desc = "document symbols",
			mode = "lsp_document_symbols",
			focus = false,
			win = { position = "right", size = 0.3 },
			filter = {
				-- remove Package since luals uses it for control flow structures
				["not"] = { ft = "lua", kind = "Package" },
				any = {
					-- all symbol kinds for help / markdown files
					ft = { "help", "markdown" },
					-- default set of symbol kinds
					kind = {
						"Class",
						"Constructor",
						"Enum",
						"Field",
						"Function",
						"Interface",
						"Method",
						"Module",
						"Namespace",
						"Package",
						"Property",
						"Struct",
						"Trait",
					},
				},
			},
		},
	},
})

-- Configure Flash
require("flash").setup()

-- Neotree
require("neo-tree").setup()

return {}
